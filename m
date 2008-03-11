Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbYCKOHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbYCKOHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 10:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYCKOHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 10:07:24 -0400
Received: from gherkin.frus.com ([192.158.254.49]:39587 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbYCKOHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 10:07:23 -0400
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
In-Reply-To: <47D5B741.6010702@keyaccess.nl> "from Rene Herman at Mar 10, 2008
 11:33:37 pm"
To: Rene Herman <rene.herman@keyaccess.nl>
Date: Tue, 11 Mar 2008 09:07:18 -0500 (CDT)
CC: Bob Tracy <rct@frus.com>, Takashi Iwai <tiwai@suse.de>,
       ALSA devel <alsa-devel@alsa-project.org>,
       Michael Cree <mcree@orcon.net.nz>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080311140718.8B3ABDBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> No problems here, using either the ALSA or OSS interfaces. Have been 
> busy switching cards -- I have no hardware that can use anything other than 
> DMA 0, 1 or 3. First test is to see if it's ALSA or just the OSS emulation 
> though...

Both native ALSA and emulated OSS playback are broken based on last
night's testing.  Just to rule out sound hardware issues, this morning
I built a 2.6.25-rc4 kernel with OSS (sb driver), and that seems to be
working fine.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
