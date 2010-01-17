Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216Ab0AQBS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab0AQBS1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 20:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110Ab0AQBS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 20:18:26 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:50083 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab0AQBS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 20:18:26 -0500
Date: Sun, 17 Jan 2010 01:18:22 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Uwe Geuder <ubuntuLp-ugeuder@sneakemail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] console/vgacon.c: mark file-local symbol static.
Message-ID: <20100117011822.GA6272@srcf.ucam.org>
References: <1c1713c0724e7a7283fce34b0d23a2eaa929df10.1263682176.git.tfransosi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c1713c0724e7a7283fce34b0d23a2eaa929df10.1263682176.git.tfransosi@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 16, 2010 at 05:52:13PM -0500, Thiago Farina wrote:
> warning: symbol 'vgacon_text_mode_force' was not declared. Should it be static?
> 
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> ---
>  drivers/video/console/vgacon.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
> index cc4bbbe..19e474d 100644
> --- a/drivers/video/console/vgacon.c
> +++ b/drivers/video/console/vgacon.c
> @@ -112,7 +112,7 @@ static int 		vga_video_font_height;
>  static int 		vga_scan_lines		__read_mostly;
>  static unsigned int 	vga_rolled_over;
>  
> -int vgacon_text_mode_force = 0;
> +static int vgacon_text_mode_force = 0;

Should probably lose the assignment while we're at it?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
