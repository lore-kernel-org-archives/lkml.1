Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbYEHHuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbYEHHuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 03:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbYEHHt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 03:49:57 -0400
Received: from smtp1.kolej.mff.cuni.cz ([78.128.192.10]:64113 "EHLO
	smtp1.kolej.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYEHHt4 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 03:49:56 -0400
X-Envelope-From: zajio1am@artax.karlin.mff.cuni.cz
Date: Thu, 8 May 2008 09:18:09 +0200
From: Ondrej Zajicek <santiago@crfreenet.org>
To: JosephChan@via.com.tw
Cc: akpm@linux-foundation.org, geert@linux-m68k.org,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 6/9] viafb: VIA Frame Buffer Device Driver
Message-ID: <20080508071809.GA11121@localhost.localdomain>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67759@exchtp03.taipei.via.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67759@exchtp03.taipei.via.com.tw>
X-Operating-System: Debian GNU/Linux 4.0 (Etch)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 07:09:42PM +0800, JosephChan@via.com.tw wrote:
> diff -Nur a/drivers/video/via/viafb.modes b/drivers/video/via/viafb.modes
> --- a/drivers/video/via/viafb.modes	1969-12-31 19:00:00.000000000 -0500
> +++ b/drivers/video/via/viafb.modes	2008-04-29 02:51:27.000000000 -0400
> @@ -0,0 +1,870 @@
> +#
> +#
> +#   These data are based on the CRTC parameters in
> +#
> +#       VIA Integration Graphics Chip
> +#       (C) 2004 VIA Technologies Inc.

Configuration file for fbset definitely shouldn't be here between C
source files. If it is needed, then it should be somewhere in
Documentation/fb .

BTW, Are these modes common VESA modes (DVT, GTF or CVT)  or some
other modes. In first case there is probably no reason to include
them.

-- 
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."
