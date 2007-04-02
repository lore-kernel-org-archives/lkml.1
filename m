Return-Path: <linux-kernel-owner+w=401wt.eu-S1751143AbXDBPZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbXDBPZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 11:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbXDBPZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 11:25:57 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:60731 "EHLO
	outbound3-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143AbXDBPZ4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 11:25:56 -0400
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: System hang on athlon64 cpufreq change
Date: Mon, 2 Apr 2007 10:25:46 -0500
Message-ID: <1449F58C868D8D4E9C72945771150BDFD967C9@SAUSEXMB1.amd.com>
In-Reply-To: <c43b2e150704010946h5442897cyb8a125decd90b2aa@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: System hang on athlon64 cpufreq change
Thread-Index: Acd0fUZLHZEHawo0RceGmF6vwW3vrgAvUfvg
References: <c43b2e150703161151i3bf45074v54208542ca2212d3@mail.gmail.com>
 <1449F58C868D8D4E9C72945771150BDFD96725@SAUSEXMB1.amd.com>
 <c43b2e150704010946h5442897cyb8a125decd90b2aa@mail.gmail.com>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "wixor" <wixorpeek@gmail.com>
cc: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 02 Apr 2007 15:25:47.0379 (UTC)
 FILETIME=[3018A430:01C7753B]
X-WSS-ID: 6A0FFFF12EW2890917-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 
> On 3/16/07, Langsdorf, Mark <mark.langsdorf@amd.com> wrote:
> > The processor is not changing frequency in response to your
> > launch of mplayer.  The powersave governor forces it to the
> > lowest frequency regardless of system load.  You really want
> > to use ondemand for dynamic frequency scaling.
> >
> > Can you use a serial or network console to capture any messages
> > the kernel is sending when mplayer starts?
> >
> Well, that's the point - i fix cpu speed at 1ghz and everything works
> UNTIL I launch mplayer. I've just reproduced this (set governor,
> launched mplayer and waited 15-20 mins) and the whole system seems
> frozen - just like before. Network is down (no responses to ping). How
> to redirect dmesg to serial port? (I'm running 2.6.19 kernel and
> 8.34.8 fglrx driver.)

My point is that is there is no cpufreq change when you
start mplayer with the powersave governor.  Have you 
disabled powernow! entirely (by removing the module) and
demonstrated that mplayer works on your machine at all?

To redirect the console, add console=ttyS0,115200 to your 
kernel command line and run a serial console from the serial 
port on the test machine to another machine, and then use your 
preferred serial port capture program (minicom or whatever) 
to capture the text.
 
> Thanks and sorry for 2week delay... (btw - now it is you [ati] who is
> responsible for both my cpu and gpu drivers, yes? :D)

AMD bought ATI, not the other way around.  That said, elements
of AMD are responsible for the PowerNow! driver, and other 
elements of AMD are responsible for the fglrx driver.

-Mark Langsdorf
Operating Systems Research Center
AMD, Inc.


