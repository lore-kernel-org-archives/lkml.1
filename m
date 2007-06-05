Return-Path: <linux-kernel-owner+w=401wt.eu-S1763761AbXFEHnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763761AbXFEHnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 03:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759762AbXFEHns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 03:43:48 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:21950 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759617AbXFEHnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 03:43:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=VgC+6vOioHDSHZz/VFzyWTV8k/kizOTXt0xheCdKFIhiM0+4/XQTVKlRZMXqcCrZINsZUeIhar38oq3lqmwF6GWJDwnz80txAB8ImbgoxLVq6C5gc7ekFv+yAQKmDdO7iZFi9hi98lVj2RchdP5Em0Z4crhgBmVfFEZcTZgjKfA=
Date: Tue, 5 Jun 2007 15:44:31 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeff Garzik <jeff@garzik.org>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <rdunlap@xenotime.net>, Al Viro <viro@ftp.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels
Message-ID: <20070605074431.GB2060@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: "H. Peter Anvin" <hpa@zytor.com>,
	Jeff Garzik <jeff@garzik.org>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Al Viro <viro@ftp.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070603142939.GW4095@ftp.linux.org.uk> <20070603074552.430c3d02.rdunlap@xenotime.net> <4662DFCF.3010606@garzik.org> <46644B97.2010506@zytor.com> <Pine.LNX.4.61.0706041935290.20829@yvahk01.tjqt.qr> <46644F57.80005@zytor.com> <20070604175751.GB3437@dhcp83-182.boston.redhat.com> <20070605021027.GD2498@localhost.localdomain> <20070605021210.GG31462@havoc.gtf.org> <4664CAFF.2040300@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4664CAFF.2040300@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 07:31:27PM -0700, H. Peter Anvin wrote:
>Jeff Garzik wrote:
>>>
>>> So, it seems that we can reach an agreement. Any other comments or suggestions?
>>> Or can someone ack/merge this patch?
>> 
>> Honestly, I think not reaching an agreement is a good thing.
>> 
>> "style" is always ultimately in the eye of the beholder, and reasoned
>> people come up with multiple answers to the same question.
>> 
>> Sometimes it's better _not_ to set things in stone.  "use your
>> judgement" and "follow the existing style" go a long way.
>> 
>
>Indeed.  Quite frankly, style guides would be a lot less obnoxious if
>there weren't always people who felt the need to "correct" other
>people's styles.  That is usually a rather obnoxious thing to do, at
>least as long as the code is reasonably clean to start out with.
>

I find things about coding style can easily lead to flamewars anywhere.

Maybe this patch is considered harmful as goto statements once were. ;-p

