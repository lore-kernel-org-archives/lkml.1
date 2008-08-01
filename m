Return-Path: <linux-kernel-owner+w=401wt.eu-S1760007AbYHAV5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbYHAV5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbYHAV5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:57:15 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:51327 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbYHAV5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:57:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XOEL9Jdwd4IolZU5EaPIfs6Pp59SfOan2Wx/veLyiHdMGNreW3gEjjjVUNJJRnEc3Z
         0mypx/x4Vq9sQB1tcndgCQZT/g5JKBCBXA1Ep83PCrKGJvqwJ75PoK0cHdFYoK7d4m10
         3yC+aorgTDUBB5bxZ64yVmHo6lS+lMwBGNZuE=
Message-ID: <86802c440808011457g5b72d69bq768cf815046957ec@mail.gmail.com>
Date: Fri, 1 Aug 2008 14:57:13 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 00/16] dyn_array and nr_irqs support v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <86802c440808011430i6cf5cb8cn519777a78dd987b0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
	 <m1iqukwjjg.fsf@frodo.ebiederm.org>
	 <86802c440808011430i6cf5cb8cn519777a78dd987b0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2008 at 2:30 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Fri, Aug 1, 2008 at 1:46 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:

>> http://lkml.org/lkml/2008/7/10/439

you moved kstat_irqs to irqdesc, and it will not numa-aware. if
irq_desc is not go with every cpu.

YH
