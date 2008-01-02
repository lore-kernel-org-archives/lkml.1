Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbYABATn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbYABATn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 19:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756175AbYABATf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 19:19:35 -0500
Received: from fmmailgate09.web.de ([217.72.192.184]:50337 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbYABATe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 19:19:34 -0500
Date: Wed, 02 Jan 2008 01:19:33 +0100
Message-Id: <80670983@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Subject: [BUG] crash - module radio-sf16fmr2 and esp interfere
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18/t4HQi5OEXVWJa5tgfKCJHPlPquL7X9uY1FhAXLqr03y4/
 ej3dzvXD9NZff+NUjLEX/a8Al/t7/6Fc3uxDV3DaFOlSoqRAXE=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

same with radio-sf16fmr2 and esp

after repeatedly modrpobe/modprobe -r  radio-sf16fmr2,  i can hang my system when loading esp afterwards

before loading esp, doing a "cat /proc/ioport" segfaults

this is with 2.6.24rc6 and also with 2.6.22

i have found these issues by running some (probably sick :D )  module load/unload test across all modules 


> -----Ursprüngliche Nachricht-----
> Von: devzero@web.de
> Gesendet: 01.01.08 21:46:30
> An: linux-kernel@vger.kernel.org
> Betreff: Re: [BUG] crash - module l440gx buggy ? interfere

> 
> same/similar behaviour with 
> 
> l440gx and container
> l440gx and acpiphp
> 
> after load of l440gx, container and acpiphp modules do also hang my system on load/unload.
> 
> maybe l440gx leaving the system in some weird state after probe ?
> 
> 
> > -----Ursprüngliche Nachricht-----
> > Von: <devzero@web.de>
> > Gesendet: 01.01.08 20:57:08
> > An: linux-kernel@vger.kernel.org
> > Betreff: [BUG] crash - modules l440gx and parport_pc interfere
> 
> 
> > 
> > there seems some weird interference between l440gx and parport_pc modules
> > 
> > i can reproduceable crash my box by either:
> > 
> > modprobe parport_pc;modprobe l440gx;rmmod parport_pc
> > 
> > or
> > 
> > modprobe l440gx; modprobe parport_pc;rmmod parport_pc
> > 
> > this happens on 2.6.24rc6 and also older kernel (2.6.22)
> > 
> > nothing in dmesg - just 
> > >JEDEC: Found no L440GX BIOS device at location zero
> > >JEDEC probe on BIOS chip failed. Using ROM
> > 
> > because i haven`t appropriate hardware.
> > 
> > don`t know if this is a bug in parport_pc or l440gx but maybe its worth reporting.
> > 
> > regards
> > roland
> 
> 


_______________________________________________________________________
Jetzt neu! Schützen Sie Ihren PC mit McAfee und WEB.DE. 30 Tage
kostenlos testen. http://www.pc-sicherheit.web.de/startseite/?mc=022220

