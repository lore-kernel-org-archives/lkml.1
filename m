Return-Path: <linux-kernel-owner+w=401wt.eu-S1751554AbYC3FS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbYC3FS0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 01:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbYC3FSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 01:18:16 -0400
Received: from gherkin.frus.com ([192.158.254.49]:36714 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbYC3FSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 01:18:16 -0400
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
In-Reply-To: <47E86203.5090805@keyaccess.nl> "from Rene Herman at Mar 25, 2008
 03:22:59 am"
To: Rene Herman <rene.herman@keyaccess.nl>
Date: Sun, 30 Mar 2008 00:18:14 -0500 (CDT)
CC: Michael Cree <mcree@orcon.net.nz>, Bob Tracy <rct@frus.com>,
       Takashi Iwai <tiwai@suse.de>, ALSA devel <alsa-devel@alsa-project.org>,
       linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080330051814.5D9CCDBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> Lovely, so different problem between you and Bob. When you (either of you) 
> have some time for it again, could you try:
> 
> $ sox asskickd.wav -w -t alsa hw

Tight loop at the beginning of the file: rapid continuous repeat of approx.
the first couple tenths of a second.  Hitting <ctrl>C caused playback to
advance to the next small section of the soundfile.  Further <ctrl>C's did
nothing I noticed: had to type <ctrl>\ to kill sox.

> $ sox asskickd.wav -w -r 44100 -t alsa hw

Several seconds of silence, followed by what sounded like continuous pitched
machine-gun fire.  Each <ctrl>C advanced through the file (the pitch of the
machine-gun fire changed slightly).  Still had to type <ctrl>\ to kill sox.

> $ sox asskickd.wav -w -r 44100 -c 2 -t alsa hw

Silence for longer than I had patience to wait :-).  Hitting <ctrl>C several
times finally got me to an even more rapid machine-gun fire than the previous
test.  As in the previous test, each <ctrl>C advanced further through the file,
although the perceived increment was smaller.  Still had to type <ctrl>\ to
kill sox.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
