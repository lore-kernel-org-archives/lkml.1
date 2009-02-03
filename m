Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbZBCRvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbZBCRvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbZBCRva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:51:30 -0500
Received: from mail-08.jhb.wbs.co.za ([196.2.97.5]:13116 "EHLO
	mail-08.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbZBCRv3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:51:29 -0500
X-Greylist: delayed 609 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Feb 2009 12:51:28 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AicCAMcPiEnEAmHFd2dsb2JhbACUKAEXDxMEuyOEFAaCKw
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: ge kills my machine
Date: Tue, 3 Feb 2009 19:41:14 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <20090203141400.11911hi0w7trf194@mail.your-server.de>
In-Reply-To: <20090203141400.11911hi0w7trf194@mail.your-server.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902031941.14164.bonganilinux@mweb.co.za>
X-Original-Subject: Re: ge kills my machine
X-Scan-Signature: 7d81172d17575799909ee4e83b6d9340
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009 15:14:00 Thomas Meyer wrote:
> Hello,
>
> Shortly after starting google earth my machine is dead.
> Google earth version is unknown. Strings command tells: "Jul  8 2008"
> and "18:49:53".
> Before I was able to start google earth I needed to do:
> "chcon -t textrel_shlib_t /opt/googleearth/lib*.so"
> Because selinux prevented the execution of the libraries.
>

Switch to a terminal Ctrl+Alt+Fn

run google earth from there to see if X is dying or the kernel is dying

DISPLAY=:0 google-earth (or whatever the binary is called)

if you can switch between terminals, the X is your problem (try a stable 
driver)


> Kernel version I encountered the hang is:
> 2.6.27.12-170.2.5.fc10.i686
> and
> v2.6.29-rc3-430-gb1792e3
>
> x11 driver is a self compiled radeonhd:
> 1.2.4-24-gb76bfbd
>
> libdrm version is
> $ yum info libdrm
> Installierte Pakete
> Name       : libdrm
> Architektur : i386
> Version    : 2.4.0
> Ausgabe    : 0.21.fc10
> Grösse     : 68 k
> Repo       : installed
>
> I tried to capture a possible oops via netconsole (eth0), but I got
> nothing back.
>
> Ideas for solving this problem are welcome!
>
> Greets
> thomas
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


