Return-Path: <linux-kernel-owner+w=401wt.eu-S1753163AbZG2GyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbZG2GyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 02:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbZG2GyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 02:54:09 -0400
Received: from smtp.witbe.net ([81.88.96.48]:50324 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbZG2GyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 02:54:08 -0400
Date: Wed, 29 Jul 2009 08:54:02 +0200
From: Paul Rolland <rol@as2917.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, rol@witbe.net
Subject: Re: Linux-2.6.31-rc4 - shut the annoying "failed to acquire
 vblank..."
Message-ID: <20090729085402.3bb7e3d9@tux.DEF.witbe.net>
In-Reply-To: <20090728092319.52ea57f1@jbarnes-g45>
References: <20090728091622.50e9933b@tux.DEF.witbe.net>
	<200907281244.13467.elendil@planet.nl>
	<20090728145359.252ff759@tux.DEF.witbe.net>
	<20090728092319.52ea57f1@jbarnes-g45>
Organization: AS2917.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.2; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/nhI2IpiS0lN+0Y9VWLRpT+7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/nhI2IpiS0lN+0Y9VWLRpT+7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Linus,

On Tue, 28 Jul 2009 09:23:19 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Tue, 28 Jul 2009 14:53:59 +0200
> Paul Rolland <rol@as2917.net> wrote:
> 
> > Hi Frans,
> > 
> > On Tue, 28 Jul 2009 12:44:12 +0200
> > Frans Pop <elendil@planet.nl> wrote:
> > 
> > > > I sent a mail long ago about this message :
> > > > tux kernel: [drm:drm_wait_vblank] *ERROR* failed to acquire vblank
> > > > counter, -22 showing up more than 10 times per second, but was
> > > > told that I had some old userspace apps running... As I was using
> > > > an old FC8, I forgot about it.
> > > 
> > > The message does not only show with old applications, it also shows:
> > > - every time I suspend my notebook
> > > - every time I start a second X session to log in as a different
> > > user
> > Well, with the so-called "old apps", it's 20 times per second, as
> > long as the app is running, which really makes it painful, because it
> > causes all the logs to show off quickly :(
> >  
> > > I agree that the message is very annoying and would be glad to be
> > > rid of it, especially as the only comment from the maintainers so
> > > far has been to just ignore it.
> > Well, I'd really like some feedback from the maintainer... because if
> > no one cares, I agree it should be removed.
> > 
> > > IMHO, If it is "ignoreable", then it is also "suppressable".
> > Seconded, unless someone is using it to try to fix the problem ?
> 
> It indicates a userland problem, and yes we shouldn't print that
> message.  I've also posted a patch to quiet it a few times, but Dave
> hasn't picked it up yet.  Feel free to send it straight to Linus with
> my Reviewed-by if you want.

Could you please apply the included patch ?

Some applications/hardware combinations are triggering the message "failed to 
acquire vblank counter" to be issued up to 20 times a second, which makes it 
both useless and dangerous, as this may hide other important messages.
This changes makes it only appear when people are debugging.

Signed-off-by: Paul Rolland <rol@as2917.net>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

--- linux-2.6.31-rc4/drivers/gpu/drm/drm_irq.c.orig	2009-07-26 21:36:20.000000000 +0200
+++ linux-2.6.31-rc4/drivers/gpu/drm/drm_irq.c	2009-07-26 21:36:34.000000000 +0200
@@ -566,7 +566,7 @@ int drm_wait_vblank(struct drm_device *d
 
 	ret = drm_vblank_get(dev, crtc);
 	if (ret) {
-		DRM_ERROR("failed to acquire vblank counter, %d\n", ret);
+		DRM_DEBUG("failed to acquire vblank counter, %d\n", ret);
 		return ret;
 	}
 	seq = drm_vblank_count(dev, crtc);



-- 
Paul Rolland                                E-Mail : rol(at)witbe.net
CTO - Witbe.net SA                          Tel. +33 (0)1 47 67 77 77
Les Collines de l'Arche                     Fax. +33 (0)1 47 67 77 99
F-92057 Paris La Defense                    RIPE : PR12-RIPE

Please no HTML, I'm not a browser - Pas d'HTML, je ne suis pas un
navigateur "Some people dream of success... while others wake up and work
hard at it" 

"I worry about my child and the Internet all the time, even though she's
too young to have logged on yet. Here's what I worry about. I worry that 10
or 15 years from now, she will come to me and say 'Daddy, where were you
when they took freedom of the press away from the Internet?'"
--Mike Godwin, Electronic Frontier Foundation 

--MP_/nhI2IpiS0lN+0Y9VWLRpT+7
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=drm.patch

--- linux-2.6.31-rc4/drivers/gpu/drm/drm_irq.c.orig	2009-07-26 21:36:20.000000000 +0200
+++ linux-2.6.31-rc4/drivers/gpu/drm/drm_irq.c	2009-07-26 21:36:34.000000000 +0200
@@ -566,7 +566,7 @@ int drm_wait_vblank(struct drm_device *d
 
 	ret = drm_vblank_get(dev, crtc);
 	if (ret) {
-		DRM_ERROR("failed to acquire vblank counter, %d\n", ret);
+		DRM_DEBUG("failed to acquire vblank counter, %d\n", ret);
 		return ret;
 	}
 	seq = drm_vblank_count(dev, crtc);

--MP_/nhI2IpiS0lN+0Y9VWLRpT+7--
