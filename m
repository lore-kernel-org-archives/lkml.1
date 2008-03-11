Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbYCKUAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbYCKUAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYCKUA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:00:27 -0400
Received: from mx5.orcon.net.nz ([219.88.242.55]:35891 "EHLO mx5.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbYCKUA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:00:26 -0400
Cc: Rene Herman <rene.herman@keyaccess.nl>, Takashi Iwai <tiwai@suse.de>,
       ALSA devel <alsa-devel@alsa-project.org>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Message-Id: <ED0F0070-B876-4D8B-8F88-879E01AB4326@orcon.net.nz>
From: Michael Cree <mcree@orcon.net.nz>
To: Bob Tracy <rct@frus.com>
In-Reply-To: <20080311180831.8CE90DBA3@gherkin.frus.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
Date: Wed, 12 Mar 2008 09:00:13 +1300
References: <20080311180831.8CE90DBA3@gherkin.frus.com>
X-Mailer: Apple Mail (2.919.2)
X-DSPAM-Check: by mx5.orcon.net.nz on Wed, 12 Mar 2008 09:00:16 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed Mar 12 09:00:23 2008
X-DSPAM-Confidence: 0.8505
X-DSPAM-Improbability: 1 in 570 chance of being spam
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2008, at 7:08 AM, Bob Tracy wrote:

> Rene Herman wrote:
>> This is behaviour consistent with the IRQ being dead ...
>>
>> I suppose it used to work and I suppose the behaviour
>> you are describing above is 100% repeatable?
>
> I can't tell you exactly *when* it used to work, or even *if* it did
> with 2.6 kernels.  I'll try to explain...
>
> Sometime back in the 2.6.14 to 2.6.16 timeframe there was an issue  
> with
> the ALSA driver not recognizing interrupts (causing looping)

Yes, the ESS1888 driver failed to work on Alpha about the 2.6.14 to  
2.6.16 kernel.   It came right with alsa release 1.0.13 (IIRC) and I  
have been running the ESS1888 driver on an Alpha XP1000 without  
problems for about a year.  I have been using mocp and mplayer on a  
fairly regular basis.  My Mplayer version uses the OSS interface by  
default.  Not sure, off-hand, what mocp is using.

For the last three months I have been playing with other sound cards  
(the quality of sound from the ESS1888 leaves a lot to be desired,  
imho) and haven't used the ESS1888 recently, so if a regression has  
been introduced after kernel 2.6.22 then it is likely I wouldn't see it.

Sorry, but I am not in a good position to do testing of the ESS1888 at  
the moment.  A week or so ago my system and home partitions shat  
themselves and I had to reinstall from 3 month old backups.  It has  
just happened again - two nights ago.  Don't know what is causing it -  
whether it is hardware fault (I can't find any disc block errors), the  
2.6.24.2 (and 2.6.24.3) kernels I had recently upgraded to, or the  
recent update from Debian testing, or the switch from the internal  
SCSI card and disc to an installed SATA card and disc that I did three  
months ago (though that one has worked for the first two and a half  
months without flaw).  Maybe I should start a new thread with a report  
of that just in case it is a kernel problem???

Michael.

