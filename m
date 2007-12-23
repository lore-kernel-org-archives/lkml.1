Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbXLWGHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbXLWGHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 01:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbXLWGHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 01:07:46 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:32955 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750850AbXLWGHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 01:07:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eMy1iY8l+4oWAaaUoF7ZSwu3LhhiXytooYXBZAcG1FXSFf2Z97GwVZZruq90+bUXsp6forbskXrLlFHhXw4gEOk9eMu68ckBjlcP4MZA9sJIFsAeSqYAokc0BAb1XcrinrE9qhAXhkFSjtEybByV5jcYCQfvGtbQonIjOPjshuI=  ;
X-YMail-OSG: BbRDrJsVM1nR4Oyz9dt3Wu6.vSbmVjXrs56P.._GLsMnO.hAbo1FVS_CA.q2UCLbDcrTvtqGng--
From: David Brownell <david-b@pacbell.net>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: [RFC] USB Kconfig: Declutter USB Kconfig Menu
Date: Sat, 22 Dec 2007 22:07:43 -0800
User-Agent: KMail/1.9.6
Cc: jengelh@computergmbh.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, greg@kroah.com
References: <200712211630.03426.a1426z@gawab.com> <20071222072208.A0960230DE8@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <200712221649.55831.a1426z@gawab.com>
In-Reply-To: <200712221649.55831.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200712222207.43483.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 December 2007, Al Boldi wrote:
> Provided there is agreement, and we go with < >, it would mean a slight 
> change to Host side USB, like this (note new USB Core Config sub-menu):
> 
>       --- Support for Host-side USB
>       [ ]   USB Core Config  --->

Maybe.  Let's see what you turn up.

>       [ ]   USB Host Controller Drivers  --->

Having at least one HCD is *NOT* optional.  ;)

And for that matter, I sometimes look at HCDs as part of the core.
The layering there is fuzzier than usual, though it's getting better
now that we've started to phase out the old Linux 2.2-ish interface.


>       ---   NOTE: USB_STORAGE needs SCSI, and 'SCSI disk support' may
>       ---   also be needed; see USB_STORAGE Help for more information
>       < >   USB Mass Storage support  --->
>       [ ]   The shared table of common (or usual) storage devices
>       [ ]   USB Monitor
>       < >   USS720 parport driver
>       < >   USB Serial Converter support  --->
>       < >   USB DSL modem support  --->
>       [ ]   USB Device Class drivers  --->
>       [ ]   USB Imaging devices  --->
>       [ ]   USB Miscellaneous drivers  --->
> 


