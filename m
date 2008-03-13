Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbYCMEYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbYCMEYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 00:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750749AbYCMEYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 00:24:09 -0400
Received: from gherkin.frus.com ([192.158.254.49]:51945 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbYCMEYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 00:24:08 -0400
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
In-Reply-To: <47D8473A.3060806@keyaccess.nl> "from Rene Herman at Mar 12, 2008
 10:12:26 pm"
To: Rene Herman <rene.herman@keyaccess.nl>
Date: Wed, 12 Mar 2008 23:24:02 -0500 (CDT)
CC: Bob Tracy <rct@frus.com>, Michael Cree <mcree@orcon.net.nz>,
       Takashi Iwai <tiwai@suse.de>, ALSA devel <alsa-devel@alsa-project.org>,
       linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080313042402.CE3D7DBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> Okay, and applying the attached just makes your sound completely dead in the 
> water?
> (patch to delete es1888_init function)

Oddly enough, the patch had no effect whatsoever (at least with the
ALSA drivers: I didn't try building a kernel with the OSS "sb" driver).
Just to make sure I wasn't "benefiting" from initialization inherited
from a prior boot, I even powered-down the machine for 30 seconds
before booting on the new kernel.  snd-sb8 still works, and snd-es18xx
is still broken (in exactly the same way as before).

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
