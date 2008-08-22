Return-Path: <linux-kernel-owner+w=401wt.eu-S1759117AbYHVVY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117AbYHVVY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 17:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbYHVVYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 17:24:06 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:28798 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211AbYHVVYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 17:24:04 -0400
Date: Fri, 22 Aug 2008 14:23:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: Re: [Patch] Trivial: fix "*er then" typos
Message-Id: <20080822142300.6654e4dd.randy.dunlap@oracle.com>
In-Reply-To: <20080822160222.GF3053@hack.voiplan.pt>
References: <20080822160222.GF3053@hack.voiplan.pt>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008 17:02:22 +0100 WANG Cong wrote:

> 
> Obviously, these "*er then" should be "*er than".
> 
> Signed-off-by: WANG Cong <wangcong@zeuux.org>
> Cc: trivial@kernel.org

Mostly good...


> diff --git a/drivers/media/video/usbvideo/ibmcam.c b/drivers/media/video/usbvideo/ibmcam.c
> index 59166b7..caf4306 100644
> --- a/drivers/media/video/usbvideo/ibmcam.c
> +++ b/drivers/media/video/usbvideo/ibmcam.c
> @@ -488,7 +488,7 @@ static enum ParseState ibmcam_parse_lines(
>  	 * Now we are sure that entire line (representing all 'scanLength'
>  	 * pixels from the camera) is available in the buffer. We
>  	 * start copying the line left-aligned to the V4L buffer.
> -	 * If the camera line is shorter then we should pad the V4L
> +	 * If the camera line is shorter than we should pad the V4L

This one should remain as "then".

>  	 * buffer with something (black) to complete the line.
>  	 */
>  	assert(frame->data != NULL);
> @@ -703,7 +703,7 @@ static enum ParseState ibmcam_model2_320x240_parse_lines(
>  	 * pixels from the camera) is available in the scratch buffer. We
>  	 * start copying the line left-aligned to the V4L buffer (which
>  	 * might be larger - not smaller, hopefully). If the camera
> -	 * line is shorter then we should pad the V4L buffer with something
> +	 * line is shorter than we should pad the V4L buffer with something

ditto.

>  	 * (black in this case) to complete the line.
>  	 */
>  	f = frame->data + (v4l_linesize * frame->curline);

> diff --git a/fs/ubifs/shrinker.c b/fs/ubifs/shrinker.c
> index f248533..bfe0920 100644
> --- a/fs/ubifs/shrinker.c
> +++ b/fs/ubifs/shrinker.c
> @@ -65,7 +65,7 @@ atomic_long_t ubifs_clean_zn_cnt;
>   * @contention: if any contention, this is set to %1
>   *
>   * This function traverses TNC tree and frees clean znodes. It does not free
> - * clean znodes which younger then @age. Returns number of freed znodes.
> + * clean znodes which younger than @age. Returns number of freed znodes.

                   which are younger

>   */
>  static int shrink_tnc(struct ubifs_info *c, int nr, int age, int *contention)
>  {



---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
