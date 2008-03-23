Return-Path: <linux-kernel-owner+w=401wt.eu-S1759402AbYCWJsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbYCWJsy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbYCWJsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 05:48:45 -0400
Received: from mx3.orcon.net.nz ([219.88.242.53]:50209 "EHLO mx3.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbYCWJsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 05:48:43 -0400
Message-ID: <47E62776.9000107@orcon.net.nz>
Date: Sun, 23 Mar 2008 22:48:38 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Bob Tracy <rct@frus.com>
CC: Rene Herman <rene.herman@keyaccess.nl>, Takashi Iwai <tiwai@suse.de>,
       ALSA devel <alsa-devel@alsa-project.org>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
References: <20080311180831.8CE90DBA3@gherkin.frus.com> <ED0F0070-B876-4D8B-8F88-879E01AB4326@orcon.net.nz>
In-Reply-To: <ED0F0070-B876-4D8B-8F88-879E01AB4326@orcon.net.nz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx3.orcon.net.nz on Sun, 23 Mar 2008 22:48:40 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun Mar 23 22:48:41 2008
X-DSPAM-Confidence: 0.7776
X-DSPAM-Improbability: 1 in 351 chance of being spam
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Cree wrote:
>> I can't tell you exactly *when* it used to work, or even *if* it did
>> with 2.6 kernels.  I'll try to explain...
>>
>> Sometime back in the 2.6.14 to 2.6.16 timeframe there was an issue with
>> the ALSA driver not recognizing interrupts (causing looping)
> 
> Yes, the ESS1888 driver failed to work on Alpha about the 2.6.14 to 
> 2.6.16 kernel.   It came right with alsa release 1.0.13 (IIRC) and I 
> have been running the ESS1888 driver on an Alpha XP1000 without problems 
> for about a year.

After thinking about this more, I am wondering if the appearance of the 
ESS1888 not working then coming right at about the 1.0.13 alsa release 
is an artefact of when I shifted from mainly using the PWS600au to 
mainly using  the XP1000, and then trying out the es18xx driver at some 
stage, finding it works on the XP1000, but forgetting that it was on the 
PWS600au that it didn't work.  It's in the distant past now and memory 
is getting hazy...

Michael.
