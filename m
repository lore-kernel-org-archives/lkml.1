Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbYKKR1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbYKKR1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 12:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbYKKR1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 12:27:46 -0500
Received: from styx.suse.cz ([82.119.242.94]:60832 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751852AbYKKR1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 12:27:45 -0500
Date: Tue, 11 Nov 2008 18:27:42 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Map missing keys to appropriate functions
In-Reply-To: <491040AA.7010208@euromail.se>
Message-ID: <alpine.LNX.1.10.0811111826270.24889@jikos.suse.cz>
References: <491040AA.7010208@euromail.se>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008, Henrik Rydberg wrote:

> On macbooks there are specific keys for the user-space functions Expose
> and Dashboard, which currently has no counterpart in input.h. This patch
> adds KEY_SCALE and KEY_DASHBOARD, and maps the keyboard accordingly.
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/hid/hid-apple.c |    5 +++--
>  include/linux/input.h   |    2 ++
[ ... ]
> diff --git a/include/linux/input.h b/include/linux/input.h
> index b86fb55..5341e82 100644
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -238,6 +238,7 @@ struct input_absinfo {
>  #define KEY_KPEQUAL		117
>  #define KEY_KPPLUSMINUS		118
>  #define KEY_PAUSE		119
> +#define KEY_SCALE		120	/* AL Compiz Scale (Expose) */
> 
>  #define KEY_KPCOMMA		121
>  #define KEY_HANGEUL		122
> @@ -322,6 +323,7 @@ struct input_absinfo {
>  #define KEY_PAUSECD		201
>  #define KEY_PROG3		202
>  #define KEY_PROG4		203
> +#define KEY_DASHBOARD		204	/* AL Dashboard */
>  #define KEY_SUSPEND		205
>  #define KEY_CLOSE		206	/* AC Close */
>  #define KEY_PLAY		207

Dmitry, could you please Ack this? Is it OK if I take it through my tree, 
together with the hid-apple mapping update? Thanks.

-- 
Jiri Kosina
SUSE Labs
