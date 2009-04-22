Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbZDVGtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbZDVGtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 02:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbZDVGtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 02:49:40 -0400
Received: from smtp.witbe.net ([81.88.96.48]:56339 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbZDVGtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 02:49:39 -0400
Date: Wed, 22 Apr 2009 08:49:08 +0200
From: Paul Rolland <rol@as2917.net>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-2.6.30-rc2 - No sound (HDA Intel) avec resume
Message-ID: <20090422084908.6a9b3525@tux.DEF.witbe.net>
In-Reply-To: <s5hhc0igecy.wl%tiwai@suse.de>
References: <20090421182448.270f0e10@tux.DEF.witbe.net>
	<s5hhc0igecy.wl%tiwai@suse.de>
Organization: AS2917.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.8; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, 21 Apr 2009 18:29:01 +0200
Takashi Iwai <tiwai@suse.de> wrote:

> Are you using pulseaudio or direct ALSA or OSS access?
Alsa.
 

> Try the very latest Linus tree, as some fix patches have been merged
> after rc2.  If it still doesn't work, run alsa-info.sh with
> --no-upload option before and after suspend, and attach the generated
> files.  The script is found at
>     http://www.alsa-project.org/alsa-info.sh

and

On Tue, 21 Apr 2009 21:11:19 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Please attach dmesg output including a suspend-resume cycle
> and /proc/iomem.

I've been trying all your suggestions, but my machine is now refusing again
to resume, either using stock -rc2, or latest Linus's git tree...
Suspend is fine, resume seems fine, but the video is not restored anymore...

I've just seen -rc3 is out, I'll try to install it and have suspend/resume
working, and then I'll restart my HDA testing.

Thanks anyway for answering me !

Regards,
Paul
