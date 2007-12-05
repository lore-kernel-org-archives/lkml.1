Return-Path: <linux-kernel-owner+w=401wt.eu-S1752399AbXLERnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbXLERnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 12:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbXLERm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 12:42:59 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50940 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750964AbXLERm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 12:42:58 -0500
Date: Wed, 5 Dec 2007 17:37:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Brett T. Warden" <brett.warden@gmail.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] bw-qcam: adds parameter aggressive to skip passive
 detection and directly attempt initialization
Message-ID: <20071205173756.0cd80e85@the-village.bc.nu>
In-Reply-To: <11968136532167-git-send-email->
References: <11968136532167-git-send-email->
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Dec 2007 16:14:13 -0800
"Brett T. Warden" <brett.warden@gmail.com> wrote:

> ---
> 
> diff --git a/drivers/media/video/bw-qcam.c b/drivers/media/video/bw-qcam.c
> index 5842352..b74a9cb 100644
> --- a/drivers/media/video/bw-qcam.c
> +++ b/drivers/media/video/bw-qcam.c
> @@ -82,11 +82,16 @@ OTHER DEALINGS IN THE SOFTWARE.
>  static unsigned int maxpoll=250;   /* Maximum busy-loop count for qcam I/O */
>  static unsigned int yieldlines=4;  /* Yield after this many during capture */
>  static int video_nr = -1;
> +static unsigned int aggressive;	

Acked-by: Alan Cox <alan@redhat.com>

Although I would suggest that "aggressive" may not be the best term - I'm
not such of a good one however - skip_passive ?
