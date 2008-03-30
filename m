Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbYC3VLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbYC3VLx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 17:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYC3VLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 17:11:45 -0400
Received: from mx3.orcon.net.nz ([219.88.242.53]:50313 "EHLO mx3.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbYC3VLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 17:11:44 -0400
Cc: Rene Herman <rene.herman@keyaccess.nl>, Takashi Iwai <tiwai@suse.de>,
       ALSA devel <alsa-devel@alsa-project.org>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Message-Id: <2C0A0DF6-7FD6-4444-A485-C0828E40F427@orcon.net.nz>
From: Michael Cree <mcree@orcon.net.nz>
To: rct@frus.com (Bob Tracy)
In-Reply-To: <20080330210759.6B20DDBA2@gherkin.frus.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
Date: Mon, 31 Mar 2008 10:11:38 +1300
References: <20080330210759.6B20DDBA2@gherkin.frus.com>
X-Mailer: Apple Mail (2.919.2)
X-DSPAM-Check: by mx3.orcon.net.nz on Mon, 31 Mar 2008 10:11:41 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Mar 31 10:11:42 2008
X-DSPAM-Confidence: 0.7997
X-DSPAM-Improbability: 1 in 400 chance of being spam
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob
>> (miata_no_mmap.diff patch)
>
> Made no difference for any of the "sox" tests, and "play" is still
> broken in the way it always has been.  However, "aplay" generated an
> interesting error I haven't seen before:
>
> $ aplay asskickd.wav
> Playing WAVE 'asskickd.wav' : Unsigned 8 bit, Rate 11025 Hz, Mono
> ALSA lib pcm_plug.c:773:(snd_pcm_plug_hw_refine_schange) Unable to  
> find an usable access for 'default'
> aplay: aplay.c:919: set_params: Assertion `err >= 0' failed.

Add in the "-D hw" option to the aplay command when using the mmap  
disabled alsa sound.

Michael.

