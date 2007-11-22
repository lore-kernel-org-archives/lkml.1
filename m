Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbXKVTyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbXKVTyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 14:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbXKVTyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 14:54:46 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:56950 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbXKVTyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 14:54:45 -0500
Date: Thu, 22 Nov 2007 20:54:42 +0100
Message-Id: <1614227@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: System reboot triggered by just reading a device file....!?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18YCeW5NYskVEuc42+aNQ/ObwE/TsuQxeP5ge6BsZzK6cHwg
 ujHuNSh9yZZhSKGFmZVaYjePKqqxiTNP3GI3IW5v3IOzUyTVjc=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

since i have gotten more or less similar answers from here, i have talked to some more people privately.

the result is interesting:
if the person i talked to was some sysadmin or related to that (i.e. some person running servers), his opinion was very similar to mine.
if the person was a developer, he didn`t really understand why i have a problem with that. "be careful if you are root" was what i got.


one of the admins gave a good statement, which i liked very much and want to share:

"even if you are root: it`s unix philosophy, that reading is harmless!"

i never thought about that, but i think that`s exactly the point and that`s why i`m feeling uncomfortable with that.

anyway - it cost me some time to find a bug which was none  and the only mistake i did was using a tool for which i was sure did nothing more than reading. so why should i care that i was root ?

need to change my own philosophy now, because i learned that reading isn`t harmless.   ;)

regards
roland




> -----Ursprüngliche Nachricht-----
> Von: "Simon Arlott" <simon@fire.lp0.eu>
> Gesendet: 21.11.07 13:30:05
> An: devzero@web.de
> CC: "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
> Betreff: Re: System reboot triggered by just reading a device file....!?


> 
> On Wed, November 21, 2007 00:01, devzero@web.de wrote:
> >>There is.. it's called "root privileges".
> > yes, true.
> >
> > but - regardless of being a windows app or not - what if you want to take a look on your system as a whole,
> > especially when using some tool which graphically shows how and where your diskspace is being used?  if i
> > let this run from ordinary useraccount it would get lot`s of "permission denied"  and then it`s only telling
> > half of the truth.....
> 
> Such a tool shouldn't need to open any files, whether they're device files or not. Do you expect it to open
> /dev/zero etc. too and read from an infinitely sized "file"?
> 
> >> > i`d wish there would be some fence around this or iTCO_wdt /dev/watchdog not being active after a
> >> default desktop installation.
> 
> Delete it?
> 
> -- 
> Simon Arlott
> 


______________________________________________________________________________
Jetzt neu! Im riesigen WEB.DE Club SmartDrive Dateien freigeben und mit 
Freunden teilen! http://www.freemail.web.de/club/smartdrive_ttc.htm/?mc=021134

