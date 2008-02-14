Return-Path: <linux-kernel-owner+w=401wt.eu-S932721AbYBNO22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721AbYBNO22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 09:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbYBNO2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 09:28:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:64932 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787AbYBNO2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 09:28:19 -0500
From: Hans-Peter Jansen <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: Re: strange SysRq problem
Date: Thu, 14 Feb 2008 15:28:11 +0100
User-Agent: KMail/1.9.6 (enterprise 20071221.751182)
Cc: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>
References: <200802140102.14252.hpj@urpla.net> <47B433C8.3030301@i4.informatik.rwth-aachen.de>
In-Reply-To: <47B433C8.3030301@i4.informatik.rwth-aachen.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802141528.11519.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX199YzaG3CECdKi6apWOpXMKIDg745dN6yLFyiS
 H6+o/g46ijLTOXLsHJZKzxHg7YFhlaPOkjWlNIzW05ut8Co/CS
 sRSdJADVWTfAi0rz+Y/Bw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 14. Februar 2008 schrieb Arnd Hannemann:
> Hans-Peter Jansen wrote:
> > I'm suffering from a strange SysRq problem:
> >
> > syslog shows haphazardly "SysRq : HELP" lines, while I definitely
> > didn't triggered them, neither via (PS/2) keyboard, nor via
> > /proc/sysrq-trigger. This is accompanied with stalls of about 15-60
> > secs.
>
> Any chance that a device connected via serial (or an USB device which
> uses USB/Serial conversion) triggers them? My cheap pl2303 device seems
> to send spurious BREAKs every once in a while, which results in the
> described behavior, as the kernel will print the help line for any
> character which is not a valid sysrq. (The probability to trigger another
> sysrq with random data is much lower, but did you find any other printout
> of an sysrq in your logs?)

Hmm, keyboard (Cherry G80-3000 LPCDE-2) and mouse (Logitech RX300) are 
connected via an equip KVM 2 port switch, but everything else is behaving 
properly, and no serial devices connected ATM. It only triggers the help 
messages, other sysrq messages are triggered at will (AFAIKS).

# grep "SysRq : HELP" /var/log/messages | wc -l
814

syslog starts at Jan 16, so you can imagine how disturbing this behavior is.

I cannot outrule some hardware defects. Will start to eliminate the KVM 
switch, but I thought, I ask here before since google also didn't revealed 
any hints..

Thanks,
Pete
