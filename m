Return-Path: <linux-kernel-owner+w=401wt.eu-S2992970AbXDFRuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992970AbXDFRuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 13:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992938AbXDFRuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 13:50:11 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:44103 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934066AbXDFRuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 13:50:10 -0400
Date: Fri, 6 Apr 2007 19:48:39 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Bart Trojanowski <bart@jukie.net>
cc: fastboot@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: restoring x86 BIOS state before reboot
In-Reply-To: <20070406154628.GG12005@jukie.net>
Message-ID: <Pine.LNX.4.61.0704061946310.6042@yvahk01.tjqt.qr>
References: <20070406154628.GG12005@jukie.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 6 2007 11:46, Bart Trojanowski wrote:
>Hi all,
>
>I am looking at a two stage boot where linux is loaded to do some system
>initialization before booting to Windows, which needs BIOS.
>
>I am interested in bypassing the BIOS on the second boot.
>
>I wanted to know if anyone has attempted to restore the BIOS memory such 
>that this could be attempted.  If not, I would love to get some pointers
>:)

Hmm.... minix3's "boot monitor" seems to be something in that direction.
When typing "halt" on minix, the system is 'shut down' and control is
passed to the boot monitor where you can select minix again.


Jan
-- 
