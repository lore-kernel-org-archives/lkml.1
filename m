Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbXIGU7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbXIGU7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 16:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbXIGU7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 16:59:13 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:40798 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbXIGU7M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 16:59:12 -0400
Subject: Re: easy alsa patches for the stable kernel?
From: Romano Giannetti <romano@dea.icai.upcomillas.es>
To: Thorsten Leemhuis <fedora@leemhuis.info>
Cc: Takashi Iwai <tiwai@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       roger@computer-surgery.co.uk, linux-kernel@vger.kernel.org,
       perex@suse.cz
In-Reply-To: <46E1A9AC.1050601@leemhuis.info>
References: <20070822222902.GA28563@computer-surgery.co.uk> 
	<20070905083844.6637da1e.akpm@linux-foundation.org> 
	<s5hlkbl6qsn.wl%tiwai@suse.de> 
	<20070905091633.87cfaa81.akpm@linux-foundation.org> 
	<s5hhcm96oza.wl%tiwai@suse.de>	<1189091390.3212.3.camel@rukbat> 
	<s5hir6n6ck6.wl%tiwai@suse.de>	<1189115313.7275.5.camel@rukbat> 
	<1189153347.15955.5.camel@rukbat>	<s5h7in26aj3.wl%tiwai@suse.de> 
	<46E13E31.1050409@leemhuis.info> <s5hy7fi4oou.wl%tiwai@suse.de> 
	<46E1A9AC.1050601@leemhuis.info>
Content-Type: text/plain;
	charset=utf-8
Date: Fri, 07 Sep 2007 22:59:07 +0200
Message-Id: <1189198747.13399.10.camel@rukbat>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-07 at 21:42 +0200, Thorsten Leemhuis wrote:
> On 07.09.2007 14:58, Takashi Iwai wrote:
> >>> Ah good.  I added it to ALSA HG tree now.

Thanks. BTW, is anywhere visible the current hg tree? It seems that
http://hg-mirror.alsa-project.org/alsa-kernel/ lags a bit behind...


> It's just this line afaics...
> +       SND_PCI_QUIRK(0x1179, 0xff50, "TOSHIBA A305", ALC268_TOSHIBA),
> ...which afaics is doing nothing more then "if DMI-Data matches FOO then
> apply know workaround BAR". Is that correct or am I missing something
> here (another patch that this one depends on that isn't in 2.6.23 yet
> maybe?)?
>

Your second guess is right. That line is a patch with respect to current
mercurial tree, which is quite ahead of the current kernel alsa code.
Although I'd like to know from where Andrew pulled it, because I was not
able to find that tree on git.kernel nor alsa-project.org... :-)

> Nevertheless let me use to use this moment and say: thx for all your
> work Takashi!

Seconded. I only hope I will be able to continue to find this patch for
the next releases of the 2.6.23 kernel...

Romano




--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation.

