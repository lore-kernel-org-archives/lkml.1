Return-Path: <linux-kernel-owner+w=401wt.eu-S1760126AbYEHIPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126AbYEHIPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 04:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbYEHIPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 04:15:23 -0400
Received: from smtp1.kolej.mff.cuni.cz ([78.128.192.10]:51419 "EHLO
	smtp1.kolej.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbYEHIPV (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 04:15:21 -0400
X-Envelope-From: zajio1am@artax.karlin.mff.cuni.cz
Date: Thu, 8 May 2008 10:15:08 +0200
From: Ondrej Zajicek <santiago@crfreenet.org>
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: JosephChan@via.com.tw, linux-fbdev-devel@lists.sourceforge.net,
       akpm@linux-foundation.org, geert@linux-m68k.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 1/9] viafb: VIA Frame Buffer Device Driver - Resend
Message-ID: <20080508081508.GD11121@localhost.localdomain>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67745@exchtp03.taipei.via.com.tw> <20080507184333.7d0f1bf4.krzysztof.h1@poczta.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507184333.7d0f1bf4.krzysztof.h1@poczta.fm>
X-Operating-System: Debian GNU/Linux 4.0 (Etch)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 06:43:33PM +0200, Krzysztof Helt wrote:
> PS. I assume that your driver will replace the existing vt8623fb (CLE266?) driver when ready. Am I right?

These drivers are hardly comparable. vt8623fb supports CLE266 with VGA output only,
but allows arbitrary resolutions and pixclocks, high-res text mode and
(partially) suspend/resume. viafb implements fixed resolutions only and
have no text mode and no suspend/resume support (according to my quick
look on it).

-- 
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."
