Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbZCYB3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbZCYB3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 21:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757697AbZCYB3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 21:29:31 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41147 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757504AbZCYB3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 21:29:30 -0400
X-Sasl-enc: a84o8GUoR2TIkQERb3mgmJWoMl9hsa9DhnooDtcFUq8Y 1237944567
Date: Tue, 24 Mar 2009 22:29:25 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Cc: LKML <linux-kernel@vger.kernel.org>, jnelson@jamponi.net
Subject: Re: Thinkpad T61 - Fan running a lot of time
Message-ID: <20090325012925.GA30554@khazad-dum.debian.net>
References: <49C94620.8040309@diamondcut.com.br> <20090324232328.GA23356@khazad-dum.debian.net> <49C98280.4020402@diamondcut.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C98280.4020402@diamondcut.com.br>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009, Renato S. Yamane wrote:
> # echo level 7 > /proc/acpi/ibm/fan
> bash: echo: write error: Invalid argument
>
> How can I change fan level?

Read the driver documentation, at Documentation/laptops/thinkpad-acpi.txt.
Fan control is locked by default, for hardware safety reasons.  The docs
tell you why, how to use the fan control interface, and how to unlock it.

Also, I suggest you get used to the hwmon fan control interface on /sys,
procfs is going away sooner or later...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
