Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031760Ab0B1KUU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 05:20:20 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:49008 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031648Ab0B1KUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 05:20:19 -0500
Date: Sun, 28 Feb 2010 11:20:12 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 48/66] sound/usb/caiaq/midi.h: Checkpatch cleanup
Message-ID: <20100228102012.GH28972@buzzloop.caiaq.de>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
 <1267289508-31031-49-git-send-email-andrea.gelmini@gelma.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267289508-31031-49-git-send-email-andrea.gelmini@gelma.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 05:51:29PM +0100, Andrea Gelmini wrote:
> sound/usb/caiaq/midi.h:6: ERROR: "foo* bar" should be "foo *bar"
> 
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>

Acked-by: Daniel Mack <daniel@caiaq.de>


> ---
>  sound/usb/caiaq/midi.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/usb/caiaq/midi.h b/sound/usb/caiaq/midi.h
> index 9d16db0..380f984 100644
> --- a/sound/usb/caiaq/midi.h
> +++ b/sound/usb/caiaq/midi.h
> @@ -3,6 +3,6 @@
>  
>  int snd_usb_caiaq_midi_init(struct snd_usb_caiaqdev *dev);
>  void snd_usb_caiaq_midi_handle_input(struct snd_usb_caiaqdev *dev, int port, const char *buf, int len);
> -void snd_usb_caiaq_midi_output_done(struct urb* urb);
> +void snd_usb_caiaq_midi_output_done(struct urb *urb);
>  
>  #endif /* CAIAQ_MIDI_H */
> -- 
> 1.7.0.90.g251a4
> 
