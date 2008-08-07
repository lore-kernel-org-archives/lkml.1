Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbYHGPIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbYHGPIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 11:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYHGPIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 11:08:44 -0400
Received: from smtp.witbe.net ([81.88.96.48]:33137 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbYHGPIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 11:08:43 -0400
Date: Thu, 7 Aug 2008 12:29:20 +0200
From: Paul Rolland <rol@as2917.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, rol@witbe.net
Subject: Re: [2.6.27-rc1] Oops in sched_power_savings_store
Message-ID: <20080807122920.27f9fc69@tux.DEF.witbe.net>
In-Reply-To: <200808051444.19135.rjw@sisk.pl>
References: <20080805115447.5e9d77f0@tux.DEF.witbe.net>
	<200808051444.19135.rjw@sisk.pl>
Organization: AS2917.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.8; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, 5 Aug 2008 14:44:16 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Tuesday, 5 of August 2008, Paul Rolland wrote:
> > Hello,
> > 
> > I've booted a 2.6.27-rc1 this morning, and I got the following Oops.
> > Previously, this machine was running an FC8 -2.6.25.9-40 kernel, without
> > problem.
> > 
> > Attached is the config used. The machine is a Dell Inspiron 6400.
> 
> This problem should be fixed in the current mainline, by commit
> f718cd4add5aea9d379faff92f162571e356cc5f
> ("sched: make scheduler sysfs attributes sysdev class devices").
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f718cd4add5aea9d379faff92f162571e356cc5f

Yes, thanks that fixed it !

Regards,
Paul

-- 
Paul Rolland                                E-Mail : rol(at)witbe.net
CTO - Witbe.net SA                          Tel. +33 (0)1 47 67 77 77
Les Collines de l'Arche                     Fax. +33 (0)1 47 67 77 99
F-92057 Paris La Defense                    RIPE : PR12-RIPE

Please no HTML, I'm not a browser - Pas d'HTML, je ne suis pas un navigateur 
"Some people dream of success... while others wake up and work hard at it" 

"I worry about my child and the Internet all the time, even though she's too 
young to have logged on yet. Here's what I worry about. I worry that 10 or 15 
years from now, she will come to me and say 'Daddy, where were you when they 
took freedom of the press away from the Internet?'"
--Mike Godwin, Electronic Frontier Foundation 
