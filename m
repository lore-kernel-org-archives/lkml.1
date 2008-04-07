Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYDGHQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYDGHQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 03:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbYDGHQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 03:16:46 -0400
Received: from ic0245.upco.es ([130.206.70.245]:50243 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbYDGHQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 03:16:45 -0400
Subject: Re: 2.6.25-rc6 regression - hang on resume [Bug 10319]
From: Romano Giannetti <romanol@upcomillas.es>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org, Jesse Barnes <jesse.barnes@intel.com>,
       suspend-devel@lists.sourceforge.net
In-Reply-To: <1207290689.4511.1.camel@localhost>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
	 <pdYe6zNQVl.A.fp.nEW9HB@albercik>  <1207290689.4511.1.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-15
Date: Mon, 07 Apr 2008 09:16:42 +0200
Message-Id: <1207552602.26185.13.camel@pern>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2008-04-04 at 08:31 +0200, Soeren Sonnenburg wrote:
> On Fri, 2008-04-04 at 01:22 +0200, Rafael J. Wysocki wrote:

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10319
> > Subject		: 2.6.25-rc6 regression - hang on resume
> > Submitter	: Soeren Sonnenburg <kernel@nn7.de>
> > Date		: 2008-03-25 04:44 (10 days old)
> 
> Yes. The machine resumes and display stays black using s2ram -f -p
> (blindly typing reboot etc on keyboard does what is expected). However
> display comes back on 2.6.24.

I can add that on my laptop (toshiba U305, Intel 945GM chipset), s2ram
-f -p -m which used to work ok, in X and console, in 2.6.24 stopped to
work (I tested -rc8, but I think it's like that since a long time).
Machine resumes but the screen stays off after that, although machine is
working (exactly as Soeren said). 

On the other hand, now the plain "echo mem > /sys/power/state" works
perfectly, from X and console. So some of the magic vbe save/restore of
s2ram mess something up for this card. 

Is it a regression for my laptop (is evidently one for Soeren)? On one
side, a "used to work" setup is broken, but it worked with userspace
hacks; now it works with the plain way, and that's clearly better.

I added on Cc: Jesse, to whom I confirmed that Intel suspend/resume was
ok on Feb, 21, [1] and suspend-devel list, because now I do not know
what to do with the whitelist I sent for s2ram for this machine...

Romano 

[1] http://marc.info/?l=linux-kernel&m=120362475121590&w=2

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
