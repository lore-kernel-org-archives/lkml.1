Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbXFIHv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbXFIHv5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 03:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbXFIHvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 03:51:49 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:10789 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbXFIHvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 03:51:49 -0400
Date: Sat, 9 Jun 2007 09:51:48 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Matthieu CASTET <matthieu.castet@parrot.com>, Tom <fivemiletom@gmail.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: RE : Building kernel 2.6.21.3 for arm on cygwin
In-Reply-To: <20070608221032.GA26637@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0706090950040.4353@fbirervta.pbzchgretzou.qr>
References: <4660971E.5020609@gmail.com> <12D4B80525C5B744A216276E209921D9CE8016@MIAMI.xi-lite.lan>
 <46645DC9.8080003@gmail.com> <20070607204707.GB16634@uranus.ravnborg.org>
 <46697C5E.9060607@parrot.com> <20070608221032.GA26637@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 9 2007 00:10, Sam Ravnborg wrote:
>Hi Matthieu.
>
>Can you please try to tell what your patch actually does.
>
>As for the part added in the MAkefile you pass -lintl for Cygwin -
>but I fail to see _why_ -lintl is needed.

It is because I think .DLLs do not have something like ELF's DT_NEEDED,
hence needing to specify all libs you ever need explicitly. Quite ugly.



	Jan
-- 
