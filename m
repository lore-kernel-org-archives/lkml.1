Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbYCNNN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbYCNNN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 09:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYCNNNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 09:13:50 -0400
Received: from gherkin.frus.com ([192.158.254.49]:36948 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbYCNNNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 09:13:49 -0400
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
In-Reply-To: <47D8473A.3060806@keyaccess.nl> "from Rene Herman at Mar 12, 2008
 10:12:26 pm"
To: Rene Herman <rene.herman@keyaccess.nl>
Date: Fri, 14 Mar 2008 08:13:44 -0500 (CDT)
CC: Bob Tracy <rct@frus.com>, Michael Cree <mcree@orcon.net.nz>,
       Takashi Iwai <tiwai@suse.de>, ALSA devel <alsa-devel@alsa-project.org>,
       linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>, twhitehe@uwo.ca
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080314131344.62A59DBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> Okay, and applying the attached just makes your sound completely dead in the 
> water?
> (patch to remove es1888_init from a Miata build omitted)

A quick followup...  Since we're in agreement this isn't a regression,
I've updated my working source tree to 2.6.25-rc5.  Built the new
kernel with the patch to omit es1888_init(), and as near as I can tell,
that function does nothing useful on the Miata platform.  At the very
least, not having it makes no difference to any of the ALSA drivers I've
tried: snd-sb8 still works great, and snd-es18xx is still broken in the
same way originally described at the beginning of this long thread.

I'll try a build with the old OSS "sb" driver, and if that works ok, we
may be able to do away with es1888_init() on the Miata.  Tyson -- I
think you have a Miata if I'm remembering correctly: can you confirm
these observations?

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
