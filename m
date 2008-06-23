Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbYFWL51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbYFWL51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 07:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYFWL5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 07:57:17 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:28091 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbYFWL5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 07:57:16 -0400
Date: Mon, 23 Jun 2008 13:57:04 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>, linux-acpi@vger.kernel.org,
       Zhang Rui <rui.zhang@intel.com>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: LMSENSORS: 2.6.26-rc,  enabling ACPI Termal Zone support costs
  sensors
Message-ID: <20080623135704.2980078c@hyperion.delvare>
In-Reply-To: <485F79C6.20507@keyaccess.nl>
References: <485DA11C.7050906@keyaccess.nl>
	<485DFF35.6080008@hhs.nl>
	<485E505F.8010306@keyaccess.nl>
	<485E61DE.6020202@hhs.nl>
	<20080623120844.5f722aa6@hyperion.delvare>
	<485F79C6.20507@keyaccess.nl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rene,

On Mon, 23 Jun 2008 12:24:06 +0200, Rene Herman wrote:
> On 23-06-08 12:08, Jean Delvare wrote:
> > No, the kernel does the right thing and does not need to be modified
> > at all.
> 
> No Jean, this is totally unacceptable. No matter how you want to call 
> things, 2.6.26 is going to break important functionality on millions of 
> systems and you simply do not get to do that.

No, it's not going to be the end of the world that you predict. Please
stop being alarmist, it really doesn't help.

We are going to break hardware monitoring for users who upgrade to
kernel 2.6.26 by themselves and have enabled option "THERMAL" and are
using lm-sensors <= 2.10.6. I suspect this is a relatively small number
of users, and these are also the ones who are presumably skilled enough
to go to http://www.lm-sensors.org/, find the patch they need, and
apply it to libsensors themselves. 

We are not going to break any system using a distribution kernel
because distributions test their kernel at least to some extent before
they release it, and that kind of breakage can't go unnoticed. So,
distributions which haven't completely switched to lm-sensors 3.x yet,
will see the breakage and patch their libsensors 2.10.6 to fix it. For
what it's worth, the patch in question is in openSuse since March 17th.

For distributions who have good maintainers, there should never be any
problem anyway. We maintain and publish a list of recommended patches.
A distribution with all these patches applied should avoid all known
problems, compatibility or otherwise.

Please also realize that I personally keep the maintainers of the
Fedora, openSuse and Debian lm-sensors packages informed when I update
the list of recommended patches. If I should forget to do so and they
hit a problem, they know where to find me.

> Can you comment on the last patch posted? It's trivial:
> 
> http://lkml.org/lkml/2008/6/22/243

It's trivial and wrong, so thanks but no thanks. The bug is in
libsensors, we fix it in libsensors.

-- 
Jean Delvare
