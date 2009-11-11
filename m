Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbZKKHyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbZKKHyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbZKKHyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:54:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60666 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671AbZKKHyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:54:50 -0500
Date: Wed, 11 Nov 2009 08:54:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Daniel Mack <daniel@caiaq.de>,
       David Newall <davidn@davidnewall.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: make the default cursor shape configurable
Message-ID: <20091111075449.GA24569@elf.ucw.cz>
References: <4AF7DDC1.4090006@ladisch.de>
 <20091109095316.6283fbd6@lxorguk.ukuu.org.uk>
 <4AF7FC64.6030904@ladisch.de>
 <20091109114600.4d91b90e@lxorguk.ukuu.org.uk>
 <20091109145056.GB14091@buzzloop.caiaq.de>
 <4AF8582B.2000403@davidnewall.com>
 <20091109220944.GH14091@buzzloop.caiaq.de>
 <20091110210940.GA1590@ucw.cz>
 <20091110152605.fc8e760e.akpm@linux-foundation.org>
 <4AFA603B.6000102@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFA603B.6000102@ladisch.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [PATCH] vt: make the default cursor shape configurable
> 
> Make the default console cursor type configurable rather than
> hard-coding it.
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

ACK.

> @@ -2704,6 +2704,11 @@ and is between 256 and 4096 characters. It is defined in the file
>  	vmpoff=		[KNL,S390] Perform z/VM CP command after power off.
>  			Format: <command>
>  
> +	vt.cur_default=	[VT] Default cursor shape.
> +			Format: 0xCCBBAA, where AA, BB, and CC are the same as
> +			the parameters of the <Esc>[?A;B;Cc escape sequence;
> +			see VGA-softcursor.txt. Default: 2 = underline.
> +
>  	vt.default_blu=	[VT]
>  			Format: <blue0>,<blue1>,<blue2>,...,<blue15>
>  			Change the default blue palette of the console.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
