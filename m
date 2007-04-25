Return-Path: <linux-kernel-owner+w=401wt.eu-S2992477AbXDYJfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992477AbXDYJfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 05:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992483AbXDYJfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 05:35:36 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:44695 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992477AbXDYJff convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 05:35:35 -0400
X-Greylist: delayed 1968 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Apr 2007 05:35:34 EDT
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and 
	suspend2:hang in atomic copy)
From: Romano Giannetti <romanol@upcomillas.es>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20070425072350.GA6866@ucw.cz>
References: <200704182245.24156.mail@earthworm.de> 
	<20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de> 
	<20070418220228.GA14536@elte.hu> 
	<1176947576.5906.21.camel@nigel.suspend2.net> 
	<20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> 
	<alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> 
	<20070424212408.GD16457@elf.ucw.cz> 
	<alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org> 
	<20070425072350.GA6866@ucw.cz>
Content-Type: text/plain;
	charset=utf-8
Date: Wed, 25 Apr 2007 11:02:40 +0200
Message-Id: <1177491760.21928.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-25 at 07:23 +0000, Pavel Machek wrote:
> suspend-to-disk is a workaround for
>
>         'suspend-to-ram eats too much power' (plus some details like
>         being able to replace battery).
>

...and let me add 'suspend-to-disk' is a workaround for when s2ram does
not work for a gazillion interacting reasons (ACPI, vga bios, drm/dri,
you name it).
I am quite happy with s2ram now on my AMD-based vaio, but it started to
work with 2.6.17 kernels (Ubuntu Edgy, really), and the three years
before that suspend-to-disk (sometime Pavel's, sometime Nigel's) 
saved the day (yes, it's quite faster to use suspend-to-disk that doing
shutdown, reboot, and re-open all the applications).

So, please do not dismiss suspend-to-disk as "crap". It has its place
under the sun.

Romano

--
Romano Giannetti --- romano.giannetti@gmail.com
Sorry for the following disclaimer, it's attached by our outgoing server
and I cannot shut it up.



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation.

