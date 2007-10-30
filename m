Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbXJ3AqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbXJ3AqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 20:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbXJ3AqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 20:46:11 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:34447 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbXJ3AqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 20:46:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=cwvr9JDWIjZqUGKkwlNmfB1jCtWtPBFIyMjzrgBSiYAAt/edZPFuXj/xO6ew/nhPnOd7j88MSDlt9U2iKE+Wbad24C+PWUcypvGl7HW30saqbaVzj2fEXkLk5WBghhNTpXNTKz7YtaJ7iCOSi8o3hWYHOqBsC8f86SA7zbmM1qU=
Message-ID: <75b66ecd0710291746m7aec81bdsb6ddc0822439ff46@mail.gmail.com>
Date: Mon, 29 Oct 2007 20:46:09 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: Out-of-tree modules [was: Linux Security *Module* Framework]
Cc: "Greg KH" <greg@kroah.com>, "Tilman Schmidt" <tilman@imap.cc>,
       "Adrian Bunk" <bunk@kernel.org>, "Simon Arlott" <simon@fire.lp0.eu>,
       "Chris Wright" <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andreas Gruenbacher" <agruen@suse.de>,
       "Thomas Fricaccia" <thomas_fricacci@yahoo.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "James Morris" <jmorris@namei.org>,
       "Crispin Cowan" <crispin@crispincowan.com>,
       "Giacomo Catenazzi" <cate@debian.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0710260900280.25696@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au>
	 <471E9260.6000704@goop.org>
	 <20071023220649.5a76af82@laptopd505.fenrus.org>
	 <55615.simon.1193226629@5ec7c279.invalid>
	 <20071024125533.GE30533@stusta.de>
	 <471F8AC5.9080300@simon.arlott.org.uk>
	 <20071024223124.GI30533@stusta.de> <4721221A.1020309@imap.cc>
	 <20071026025647.GC21408@kroah.com>
	 <Pine.LNX.4.64.0710260900280.25696@fbirervta.pbzchgretzou.qr>
X-Google-Sender-Auth: 34f49e711a236f08
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> quad_dsp - http://jengelh.hopto.org/p/quad_dsp/
>
> Provides a /dev/dsp style node for legacy applications that support
> neither ALSA nor the AOSS wrapper nor more-than-2-channel sound.
>

(I think that should read "AND more than 2 channel sound")

Couldn't ALSA's OSS emulation be extended to support more than 2
channels per device node?

>
> thkd - ftp://ftp5.gwdg.de/pub/linux/misc/suser-jengelh/kernel/linux-2.6.23.1-ccj58/thkd.diff
>
> Workaround for Toshiba MK2003GAH hard-drive head auto-unloading after
> 5-15 seconds. (Ref: http://lkml.org/lkml/2006/11/15/100 )

It looks like this could be trivially fixed in a mergeable way.  That
LKML thread petered out before the problem was seriously analyzed.

Did you try the -Z flag of hdparm?

Lee
