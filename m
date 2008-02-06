Return-Path: <linux-kernel-owner+w=401wt.eu-S1761887AbYBFKJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761887AbYBFKJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 05:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760915AbYBFKJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 05:09:24 -0500
Received: from antispam.upcomillas.es ([130.206.70.245]:52772 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760848AbYBFKJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 05:09:22 -0500
Subject: Re: [PATCH] Rationalise ACPI backlight implementation
From: Romano Giannetti <romanol@upcomillas.es>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <20080202113008.GA4251@khazad-dum.debian.net>
References: <20071226020325.GA21099@srcf.ucam.org>
	 <20080128012549.GA24166@srcf.ucam.org>
	 <20080127211013.1ddaa6a1.akpm@linux-foundation.org>
	 <200802012246.13162.lenb@kernel.org>
	 <20080202113008.GA4251@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Date: Wed, 06 Feb 2008 11:09:20 +0100
Message-Id: <1202292560.21858.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 2008-02-02 at 09:30 -0200, Henrique de Moraes Holschuh wrote:
> On Fri, 01 Feb 2008, Len Brown wrote:
> > You might check if CONFIG_ACPI_VIDEO=m is set and you can load the "video" module.
> > While the sony may be non-standard and not load, your thinkpad may work.
[...]
> 
> We really need to solve the userspace mess, though.
> 

I do not know if this is relevant... but for example, with a i915 hw
here (toshiba laptop):

#cat max_brightness 
100

#echo 50 > brightness ; cat actual_brightness 
0
#echo 60 > brightness ; cat actual_brightness 
0
#echo 70 > brightness ; cat actual_brightness 
70
#echo 80 > brightness ; cat actual_brightness 
0
#echo 90 > brightness ; cat actual_brightness 
0
#echo 100 > brightness ; cat actual_brightness 
100

#uname -a
Linux rukbat 2.6.24 #13 SMP PREEMPT Fri Feb 1 13:12:23 CET 2008 i686 GNU/Linux

which is at least strange (and probably broken). actual_brightness is
real, when it says 0 backlight is off. You can imagine what happens
using the backlight up/down control... flashing lights! 

Romano


-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
