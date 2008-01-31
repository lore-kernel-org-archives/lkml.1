Return-Path: <linux-kernel-owner+w=401wt.eu-S932327AbYAaKCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327AbYAaKCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbYAaKCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:02:22 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:14635 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbYAaKCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:02:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GsbcX/DcbgPhrN4wSh6kNoWdEzSLw3vzPr1Ef71+ctSO9mNZnc2jGHnlJCmcEJT9zRDtExYpe72LRORyqJNcXNz82i8CdFb39lzNgzsaXyOLlvuE711mby52TdRfmwy44Dzq+b8TdXvaYIS/X1hBn/EKP4ae1s3cPZ9nyu/axeE=
Subject: Re: about relocs.c on x86
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080131095223.GA11867@elte.hu>
References: <86802c440801310007oe8693c7q177d41a87c27ca7@mail.gmail.com>
	 <20080131095223.GA11867@elte.hu>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 02:02:20 -0800
Message-Id: <1201773740.23523.17.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-31 at 10:52 +0100, Ingo Molnar wrote:
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> 
> > why not rename relocs.c to relocs_32.c?
> > 
> > it is only used for 32 bit, even it is host app.
> 
> during the big first phase of unification we generally kept file names 
> untouched if they were only present in one of the previous 
> architectures. I.e. pure 32-bit and pure 64-bit files were not renamed 
> to _32/_64.
> 
> Now that we've got lots of unified 32/64-bit files it might make sense 
> to rename the 'standalone' ones into _32/_64 if they share the same 
> directory with 32/64-bit source files - to reduce the confusion. And 
> given that for example arch/x86/boot/compressed/misc.c is unified while 
> arch/x86/boot/compressed/relocs.c is 32-bit only, i'd agree with your 
> observation. Feel free to send a rename patch for such cases.

I'd argue that eliminating the _32/_64 suffixes through unification and
not adding any more would be better.  Renaming at this point seems like
the wrong side of the cost/benefit line.  When the makefiles finally get
unified, that would be a natural list of what is 32 bit-only and what
is 64 bit-only, and additional suffixes wouldn't add much to that.

Just another voice,

Harvey

