Return-Path: <linux-kernel-owner+w=401wt.eu-S1764256AbYETBEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764256AbYETBEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 21:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760890AbYETBE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 21:04:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:51973 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760799AbYETBE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 21:04:28 -0400
X-Authenticated: #31440617
X-Provags-ID: V01U2FsdGVkX19QonpYDK9QZl7N9IL6sYGezimslzUh5KzdxALTyn
	Qc4WrsZYa6EVNA
Message-ID: <48322370.4060704@gmx.net>
Date: Tue, 20 May 2008 03:03:44 +0200
From: Dragan Noveski <perodog@gmx.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: problems compiling alsa-drivers-1.0.16 into 2.6.25.4 kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hallo list,
steven rostedt asked me to pass this problem to this list, so here it goes.

when running make in the alsa-driver source  i get this error:

.....
make[1]: Entering directory `/usr/src/linux-2.6.25'
  CC [M]  
/home/nowhiskey/software/nove/alsa/alsa-driver-1.0.16/acore/hwdep.o
  CC [M]  
/home/nowhiskey/software/nove/alsa/alsa-driver-1.0.16/acore/memory_wrapper.o
  CC [M]  
/home/nowhiskey/software/nove/alsa/alsa-driver-1.0.16/acore/memalloc.o
  CC [M]  
/home/nowhiskey/software/nove/alsa/alsa-driver-1.0.16/acore/sgbuf.o
  CC [M]  /home/nowhiskey/software/nove/alsa/alsa-driver-1.0.16/acore/pcm.o
  CC [M]  
/home/nowhiskey/software/nove/alsa/alsa-driver-1.0.16/acore/pcm_native.o
  CC [M]  
/home/nowhiskey/software/nove/alsa/alsa-driver-1.0.16/acore/pcm_lib.o
  CC [M]  
/home/nowhiskey/software/nove/alsa/alsa-driver-1.0.16/acore/pcm_timer.o
  CC [M]  
/home/nowhiskey/software/nove/alsa/alsa-driver-1.0.16/acore/pcm_misc.o
  CC [M]  
/home/nowhiskey/software/nove/alsa/alsa-driver-1.0.16/acore/pcm_memory.o
  CC [M]  
/home/nowhiskey/software/nove/alsa/alsa-driver-1.0.16/acore/rawmidi.o
  CC [M]  
/home/nowhiskey/software/nove/alsa/alsa-driver-1.0.16/acore/rtctimer.o
  CC [M]  
/home/nowhiskey/software/nove/alsa/alsa-driver-1.0.16/acore/timer.o
/home/nowhiskey/software/nove/alsa/alsa-driver-1.0.16/acore/timer.c: In 
function 'snd_timer_request':
/home/nowhiskey/software/nove/alsa/alsa-driver-1.0.16/acore/timer.c:155: 
error: wrong type argument to unary exclamation mark
make[3]: *** 
[/home/nowhiskey/software/nove/alsa/alsa-driver-1.0.16/acore/timer.o] 
Fehler 1
make[2]: *** 
[/home/nowhiskey/software/nove/alsa/alsa-driver-1.0.16/acore] Fehler 2
make[1]: *** 
[_module_/home/nowhiskey/software/nove/alsa/alsa-driver-1.0.16] Fehler 2
make[1]: Leaving directory `/usr/src/linux-2.6.25'
make: *** [compile] Fehler 2
......

the configure line i am using is:

./configure --with-isapnp=no --with-sequencer=yes --with-oss=yes 
--with-pcm-oss-plugins=yes 
--with-cards=virmidi,seq-dummy,hdsp,intel8x0,usb-audio 
--with-card-options=seq-rtctimer-default,support-old-api

it works on 2.6.24.7-rt7 kernel, but it don't with the 2.6.25.4 vanilla.

if you need any additional information on my system, please let me know.
since i am not subscribed to this list, it would be good you CC the 
messages of this thread to my email.

cheers,
doc
