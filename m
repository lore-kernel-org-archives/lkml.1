Return-Path: <linux-kernel-owner+w=401wt.eu-S934397AbXFFEwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934397AbXFFEwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 00:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbXFFEwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 00:52:43 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:60521 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbXFFEwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 00:52:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=QV1OiwSEt4EiC8nDQNc4JMTkcVVE6HXmM1h9sLwoAjFSwoWx0Af40/7l9lxcxcd2FUqyNCLN8/M9YK+J2n8ES0am13HFoElUm7fS3n7yKP5tm2sljOFEyn6zqJFpF4kSTjTY4yH8ZA4oFi5Dh1APl+qOiM6Z8wt04FX156qRfkM=
Date: Wed, 6 Jun 2007 12:53:15 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Rene Herman <rene.herman@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <rdunlap@xenotime.net>, Al Viro <viro@ftp.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels
Message-ID: <20070606045315.GA2379@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: Rene Herman <rene.herman@gmail.com>,
	Jeff Garzik <jeff@garzik.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Al Viro <viro@ftp.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
	Pekka Enberg <penberg@cs.helsinki.fi>
References: <20070603142450.GA4230@localhost.localdomain> <20070603142939.GW4095@ftp.linux.org.uk> <20070603074552.430c3d02.rdunlap@xenotime.net> <4662DFCF.3010606@garzik.org> <46644B97.2010506@zytor.com> <Pine.LNX.4.61.0706041935290.20829@yvahk01.tjqt.qr> <46644F57.80005@zytor.com> <20070604175751.GB3437@dhcp83-182.boston.redhat.com> <20070605021027.GD2498@localhost.localdomain> <466529DD.90605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466529DD.90605@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 11:16:13AM +0200, Rene Herman wrote:
>On 06/05/2007 04:10 AM, WANG Cong wrote:
>
>>On Mon, Jun 04, 2007 at 01:57:51PM -0400, Jeff Garzik wrote:
>
>>>A matter of opinion :)  I tend to think goto is special enough to
>>>warrant column 1 unconditionally.  It is special, so it draws additional
>>>attention over and above case labels.
>>>
>>>I and others have been tripped up when programmers "hide" goto
>>>statements among regular statements.
>>>
>>>IMO goto warrants a big flashing "notice me" sign.
>
>>Hmmm, perhaps.
>>
>>So, it seems that we can reach an agreement. Any other comments or
>>suggestions?
>
>One more -- I absolutely agree with Jeff that goto should stand out as best 
>as possible but I think that's actually more so when they're indented 2 
>columns.
>
>Have been working on a legacy CD-ROM driver lately and puting "out:" labels 
>at 2 spaces started out as a personal style preference of Pekka Enberg (I 
>used to put them at 0) but has grown on me. It makes them clearly fall 
>inside the function, not being aligned at the same level as the next 
> function header, which makes for the "lowest effort visual scan" of all I 
>feel. One is just too little for that, more than 2 is too much...
>
>Here's the last version that was posted:
>
>http://lkml.org/lkml/2007/6/4/50
>
>It gets a little different visually when labels are mostly longer than a 
>simple "out" or "again", or "error" or something like that but if someone's 
>going to try to pin down the label style, I'd like the freedom to have two 
>spaces in front of them...
>
>Rene.

I see. Thank you for your advice. Freedom is a good thing. ;)

>
>P.S: Your message had a Mail-Followup-To set which dropped yourself and 
>turned the others from CCs into TOs. If you can help it, please no header 
>tricks.

Thanks! You are very kind. I will try to fix it!

Regards!

