Return-Path: <linux-kernel-owner+w=401wt.eu-S933169AbYBUUKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169AbYBUUKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756208AbYBUUKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:10:24 -0500
Received: from ic0245.upco.es ([130.206.70.245]:56926 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758116AbYBUUKX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:10:23 -0500
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off 
	aftersuspend-to-disk. Screen becomes green.
From: Romano Giannetti <romano@dea.icai.upcomillas.es>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Dave Airlie <airlied@linux.ie>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org, Jesse Barnes <jesse.barnes@intel.com>
In-Reply-To: <b6a2187b0802201002t315548b5uac623759723842d0@mail.gmail.com>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> 
	<alpine.LFD.1.00.0802200922590.7833@woody.linux-foundation.org> 
	<b6a2187b0802200937q3ff8f470k235b5d1e00eab59e@mail.gmail.com> 
	<alpine.LFD.1.00.0802200945591.7833@woody.linux-foundation.org> 
	<b6a2187b0802201002t315548b5uac623759723842d0@mail.gmail.com>
Content-Type: text/plain;
	charset=utf-8
Date: Thu, 21 Feb 2008 20:43:22 +0100
Message-Id: <1203623002.3420.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-21 at 02:02 +0800, Jeff Chua wrote:
> On Feb 21, 2008 1:52 AM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> > Ahh. You're using the BIOS to re-initialize your video, aren't you?
>
> I don't know. Just pure simple "s2ram" without any options.

Well, as far as I know, s2ram could be doing vbe save/restore for you.
Even without parameter, if your laptop is in the whitelist.

> > Let's try to narrow it down to what the interaction is. Are you using
> > something like acpi_sleep=s3_bios or similar?
>
> No. Not additional command line option except for resume=/dev/sda3 reboot=bios

My laptop (a Toshiba satellite U305, intel 945GM chipset, used to need
s2ram -f -p -m to STR correctly. In 2.6.25-rc2 I can simply STR with
echo mem > /sys/power/state.

Romano

I imagine this will be received as blasphemy, but if only ndiswrapper
were not horribly broken, this will be my day-by-day kernel. I just hope
ath5k will arrive to my chipset soon...



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation.

