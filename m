Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641Ab0ARJQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab0ARJQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 04:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415Ab0ARJQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 04:16:48 -0500
Received: from smtp.witbe.net ([81.88.96.48]:40056 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab0ARJQo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 04:16:44 -0500
Date: Mon, 18 Jan 2010 10:16:32 +0100
From: Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
To: linux-kernel@vger.kernel.org
Cc: Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
Subject: Re: 2.6.33-rc4: i915/drm : error in execbuffer
Message-ID: <20100118101632.3dea3e1d@tux.DEF.witbe.net>
In-Reply-To: <20100116112824.432f261b@tux.DEF.witbe.net>
References: <20100116112824.432f261b@tux.DEF.witbe.net>
Organization: Witbe.net
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, 16 Jan 2010 11:28:24 +0100
Paul Rolland (ポール・ロラン)  <rol@witbe.net> wrote:

> Since I've upgraded from -rc3 to -rc4, I'm getting these errors :
> 
> [drm:i915_gem_execbuffer] *ERROR* i915_gem_do_execbuffer returns -512
> 
> They are appearing from time to time in my log messages, and I can't
> relate them to any activity I may have with the machine.

Well, it seems they are related to my KDE changing the wallpaper : this is
configured to be done every two minutes, and here is my log this morning :

Jan 18 10:07:14 tux kernel: [drm:i915_gem_execbuffer] *ERROR* i915_gem_do_execbuffer returns -512

Jan 18 10:09:14 tux kernel: [drm:i915_gem_execbuffer] *ERROR* i915_gem_do_execbuffer returns -512
Jan 18 10:09:14 tux kernel: [drm:i915_gem_execbuffer] *ERROR* i915_gem_do_execbuffer returns -512

Jan 18 10:11:14 tux kernel: [drm:i915_gem_execbuffer] *ERROR* i915_gem_do_execbuffer returns -512
Jan 18 10:11:14 tux kernel: [drm:i915_gem_execbuffer] *ERROR* i915_gem_do_execbuffer returns -512
Jan 18 10:11:14 tux kernel: [drm:i915_gem_execbuffer] *ERROR* i915_gem_do_execbuffer returns -512

Jan 18 10:13:14 tux kernel: [drm:i915_gem_execbuffer] *ERROR* i915_gem_do_execbuffer returns -512
Jan 18 10:13:14 tux kernel: [drm:i915_gem_execbuffer] *ERROR* i915_gem_do_execbuffer returns -512

Is this a real error, or should it be a warning, as -512 seems to indicate
an ERESTARTSYS ?

Regards,
Paul


