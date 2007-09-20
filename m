Return-Path: <linux-kernel-owner+w=401wt.eu-S1757648AbXITQ75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbXITQ75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 12:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbXITQ7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 12:59:49 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:38753 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbXITQ7s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 12:59:48 -0400
Subject: Re: 2.6.23-rc6: S4 and S5 no longer listed as supported on 
	ToshibaSatellite A40
From: Romano Giannetti <romanol@upcomillas.es>
To: Maciek Rutecki <maciej.rutecki@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, Pavel Machek <pavel@ucw.cz>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <46F29965.8030603@gmail.com>
References: <200709192014.08443.elendil@planet.nl> 
	<20070920105312.GC12157@atrey.karlin.mff.cuni.cz> 
	<200709201437.56431.elendil@planet.nl>  <46F29965.8030603@gmail.com>
Content-Type: text/plain;
	charset=utf-8
Date: Thu, 20 Sep 2007 18:59:42 +0200
Message-Id: <1190307582.16437.7.camel@rukbat>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-20 at 18:01 +0200, Maciek Rutecki wrote:
> Frans Pop pisze:

> >> Unexpected, and potentially pretty serious. Something went wrong with
> >> ACPI. Can you try to narrow down when it started happening?
> >
> > rc1 still had all 4 levels. I'll run a bisect between rc1 and rc6.
>
> I have the same on HP/Compaq nx6310:
> ACPI: (supports S0 S3)
>
> (kernel 2.6.23-rc6)

Linux version 2.6.20-16-generic (ubuntu):
ACPI: (supports S0 S3 S4 S5)

Linux version 2.6.23-rc2-rg (with a little snd-hda-intel patch)
ACPI: (supports S0 S3)

So it  seems  happened between rc1 and rc2

> But suspend to ram/disk works.

For me too (with s2ram, not with vanilla echo ram > ...). And the system
is otherwise ok.

	Romano

> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation.

