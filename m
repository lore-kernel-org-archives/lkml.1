Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbZLUVrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbZLUVrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 16:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757334AbZLUVrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 16:47:20 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:39204 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757156AbZLUVrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 16:47:20 -0500
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: felipe.balbi@nokia.com
Subject: Re: [Oops:] radeon KMS in 2.6.33-rc1-00154-gf7b84a6
Date: Mon, 21 Dec 2009 22:47:15 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc1; KDE/4.3.4; x86_64; ; )
Cc: Alex Deucher <alexdeucher@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>
References: <200912212238.54069.johannes.hirte@fem.tu-ilmenau.de> <20091221214235.GA11558@nokia.com>
In-Reply-To: <20091221214235.GA11558@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912212247.15265.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 21 Dezember 2009 22:42:36 schrieb Felipe Balbi:
> Hi,
> 
> On Mon, Dec 21, 2009 at 10:38:53PM +0100, ext Johannes Hirte wrote:
> >When loading the radeon module with modeset=1, the kernel oopses:
> 
> [snip]
> 
> >Dec 21 21:58:14 datengrab firmware.sh[2542]: Cannot find  firmware file
> >'radeon/R600_rlc.bin'
> 
> does it have something to do with the missing firmware file ??

Yes, I've tested with the firmware binary from 
http://people.freedesktop.org/~agd5f/radeon_ucode/ now and it works. It seems 
a fallback path is missing if no firmware is found.

regards,
  Johannes
