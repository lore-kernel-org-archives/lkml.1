Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbZJYS1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbZJYS1s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 14:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbZJYS1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 14:27:48 -0400
Received: from smtp.witbe.net ([81.88.96.48]:46610 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954AbZJYS1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 14:27:47 -0400
Date: Sun, 25 Oct 2009 19:27:49 +0100
From: Paul Rolland <rol@as2917.net>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Intel Video : screen is "flickering"
Message-ID: <20091025192749.3beb8fff@tux.DEF.witbe.net>
In-Reply-To: <200910251458.06543.elendil@planet.nl>
References: <20091025140208.35ed1476@tux.DEF.witbe.net>
	<200910251458.06543.elendil@planet.nl>
Organization: AS2917.net
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Frans,

On Sun, 25 Oct 2009 14:58:05 +0100
Frans Pop <elendil@planet.nl> wrote:

> Paul Rolland wrote:
> > I'm running a 2.6.32-rc5 kernel, and I'm facing a flickering screen with
> > X (running KDE 4.3 and compiz)...
> > It's not always, but I can't find why it starts and why it stops.
> > Some logs/traces/informations are below.
> > 
> > Is this a known issue ? Is there anything I can test to debug or to fix
> > this problem ?
> 
> This looks like the same problem reported in 
> http://lkml.org/lkml/2009/10/2/426.

Yes, that's very much what I was experiencing. Moving the mouse and typing
on the keyboard seemed to slow the rate.

Also, I'm using compiz and 5 virtual desktop, and it never seemed to affect
the first one.
 
> Could you try the patches in http://lkml.org/lkml/2009/10/18/142?
Sure. I've compiled a 2.6.32-rc5 with these patches, and I'm now running it.

I'll report after some time if it doesn't happen anymore, and sooner if the
problem's still here.

Regards,
Paul
