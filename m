Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbXHBWAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbXHBWAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 18:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbXHBWAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 18:00:43 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:1376 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbXHBWAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 18:00:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=NeEeK1VSMwTrlPhkqYunxGlnMkumGQMPuJiaoqMADbSN5/R4JNP1oDFG3rBD1gPqYJRGGA796L6boVZkAG3SEPr5M7+O4e26YwnPCeHQ2w7evg9uFCYQKMK3Gj4ykTiwN7crL1SEkrSZRVNRzyhQ+Q3XVwRgFzMMWtnRmAOs9Bo=
Message-ID: <3ae72650708021500v3de84e6vdf15d0a9e5baf661@mail.gmail.com>
Date: Fri, 3 Aug 2007 00:00:41 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: VIA EPIA EK: strange eth dev numbering
Cc: "Michael Tokarev" <mjt@tls.msk.ru>,
       "Herbert Rosmanith" <kernel@wildsau.enemy.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708022034190.9319@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708021056.l72Au722008603@wildsau.enemy.org>
	 <Pine.LNX.4.64.0708021347270.24572@fbirervta.pbzchgretzou.qr>
	 <46B1D708.9040106@msgid.tls.msk.ru>
	 <Pine.LNX.4.64.0708021536350.24572@fbirervta.pbzchgretzou.qr>
	 <Pine.LNX.4.64.0708022034190.9319@fbirervta.pbzchgretzou.qr>
X-Google-Sender-Auth: f0159f90f1f4d556
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/2/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> I know I have seen my kernel outputting "A renamed to B". Since you two
> however wanted that information in the first place, I grepped a bit
> around, and actually found, (drumroll), that the SUSE kernel has had a
> proper patch for [I can't remember how long] quite some time. (At least
> one distro which does the right thing.) I copied it below.

> e1000: eth3: e1000_probe: Intel(R) PRO/1000 Network Connection
> dev_change_name: about to rename 'eth3' to 'eth0'
> dev_change_name: about to rename 'eth3' to 'ethxx3'
> eth3 renamed to ethxx3

I just made udev when it successfully renamed an interface to write
that to the kernel log, so dmesg will show:
  <6>udev: renamed network interface eth0 to eth1

Kay
