Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbYKKEVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbYKKEVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 23:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYKKEVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 23:21:36 -0500
Received: from ipx-119-252-190-80.ipxserver.de ([80.190.252.119]:47916 "EHLO
	ipx10616.ipxserver.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752308AbYKKEVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 23:21:35 -0500
Date: Tue, 11 Nov 2008 14:20:09 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Add a detailed multi-touch finger data report
	protocol
Message-ID: <20081111042009.GC6776@dingo.redhat.com>
References: <49142351.9080805@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49142351.9080805@euromail.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 12:15:29PM +0100, Henrik Rydberg wrote:
> In order to utilize the full power of the new multi-touch devices, a
> way to report detailed finger data to user space is needed. This patch
> adds a multi-touch (MT) protocol which allows drivers to report details
> for an arbitrary number of fingers.

[...]

>  /* We avoid low common keys in module aliases so they don't get huge. */
>  #define KEY_MIN_INTERESTING	KEY_MUTE
>  #define KEY_MAX			0x2ff
> @@ -642,6 +645,15 @@ struct input_absinfo {
>  #define ABS_TOOL_WIDTH		0x1c
>  #define ABS_VOLUME		0x20
>  #define ABS_MISC		0x28
> +#define ABS_MT_TOUCH		0x30	/* Diameter of touching circle */
> +#define ABS_MT_TOUCH_MAJOR	0x30	/* Major axis of touching ellipse */
> +#define ABS_MT_TOUCH_MINOR	0x31	/* Minor axis of touching ellipse */
> +#define ABS_MT_WIDTH		0x32	/* Diameter of approaching circle */
> +#define ABS_MT_WIDTH_MAJOR	0x32	/* Major axis of approaching ellipse */
> +#define ABS_MT_WIDTH_MINOR	0x33	/* Minor axis of approaching ellipse */
> +#define ABS_MT_ORIENTATION	0x34	/* Ellipse orientation */
> +#define ABS_MT_POSITION_X	0x35	/* Center X ellipse position */
> +#define ABS_MT_POSITION_Y	0x36	/* Center Y ellipse position */
>  #define ABS_MAX			0x3f
>  #define ABS_CNT			(ABS_MAX+1)

is there hardware that can do finger identification? (i.e. thumb vs. index
finger)? Should we accommodate for this?
 
Cheers,
  Peter
