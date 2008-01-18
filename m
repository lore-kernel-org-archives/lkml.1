Return-Path: <linux-kernel-owner+w=401wt.eu-S1765350AbYARTEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765350AbYARTEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758518AbYARTEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:04:32 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:15448 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbYARTEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:04:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Pe8Agbwja4w7k3d/U/5rrdOnpvlo1CgzLX+4/H/s9r5X5TQQSXBTUayOxuAyHjJEQG1tRXN+fxFEFJmSa2HQquTSAbH9h9SzayJbU8TWiY7PboDUJlyWpD1Dv/p/VN3Y08sAJ8MdHJM2hLbrQSXvfBEmd8YWEb6iD8qgmFsgjuM=
Subject: Re: [PATCHv2] x86: Use v8086_mode helper, trivial unification
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080118150040.GB31446@elte.hu>
References: <1200615957.5724.75.camel@brick>
	 <20080118091208.GE24337@elte.hu>  <20080118150040.GB31446@elte.hu>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 11:04:34 -0800
Message-Id: <1200683074.5724.137.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-18 at 16:00 +0100, Ingo Molnar wrote:
> > > +	/*
> > > +	 * Did it hit the DOS screen memory VA from vm86 mode?
> > > +	 */
> > > +	if (v8086_mode(regs)) {
> > > +		unsigned long bit = (address - 0xA0000) >> PAGE_SHIFT;
> > > +		if (bit < 32)
> > > +			tsk->thread.screen_bitmap |= 1 << bit;
> > > +	}
> 
> this does not build on 64-bit, because screen_bitmap is 32-bit only - so 
> i had to pull the patch. I suspect a small #ifdef section would look 
> better here?
> 

My original patch had the ifdef, you can grab that one.

Harvey

