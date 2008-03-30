Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbYC3VTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbYC3VTB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 17:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYC3VSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 17:18:51 -0400
Received: from gherkin.frus.com ([192.158.254.49]:56748 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325AbYC3VSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 17:18:50 -0400
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
In-Reply-To: <2C0A0DF6-7FD6-4444-A485-C0828E40F427@orcon.net.nz>
 "from Michael Cree at Mar 31, 2008 10:11:38 am"
To: Michael Cree <mcree@orcon.net.nz>
Date: Sun, 30 Mar 2008 16:18:48 -0500 (CDT)
CC: Bob Tracy <rct@frus.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Takashi Iwai <tiwai@suse.de>, ALSA devel <alsa-devel@alsa-project.org>,
       linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080330211848.60C94DBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Cree wrote:
> Bob
> >> (miata_no_mmap.diff patch)
> >
> > Made no difference for any of the "sox" tests, and "play" is still
> > broken in the way it always has been.  However, "aplay" generated an
> > interesting error I haven't seen before:
> >
> > $ aplay asskickd.wav
> > Playing WAVE 'asskickd.wav' : Unsigned 8 bit, Rate 11025 Hz, Mono
> > ALSA lib pcm_plug.c:773:(snd_pcm_plug_hw_refine_schange) Unable to  
> > find an usable access for 'default'
> > aplay: aplay.c:919: set_params: Assertion `err >= 0' failed.
> 
> Add in the "-D hw" option to the aplay command when using the mmap  
> disabled alsa sound.

Thanks!  I now get "Maybe yo<>Maybe yo<>Maybe yo<>Maybe yo..." in an
endlessly repeating loop.  <ctrl>C is sufficient to stop playback,
however.  Still no activity on IRQ 5 seen by the ES18xx driver.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
