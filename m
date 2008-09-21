Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbYIUVAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbYIUVAP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 17:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYIUVAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 17:00:01 -0400
Received: from doppler.zen.co.uk ([212.23.3.27]:38316 "EHLO doppler.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbYIUVAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 17:00:00 -0400
Subject: Re: How how latent should non-preemptive scheduling be?
From: Matt Keenan <tank.en.mate@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <48D1741A.7010508@yahoo.com>
References: <48D1741A.7010508@yahoo.com>
Content-Type: text/plain
Date: Sun, 21 Sep 2008 21:56:55 +0100
Message-Id: <1222030615.10469.10.camel@bazbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost02-IP: [82.69.27.224]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-17 at 22:18 +0100, Sitsofe Wheeler wrote:
> Hi,
> 
> I have an EeePC 900 (Intel Celeron 900Mhz) and it seems to be skipping 
> while playing sound through various desktop apps with a 2.6.27rc6 
> kernel. It is running off an SD card which really shows up slow writes 
> but the sound is seemingly skipping even when ext3 is not being used. 

[snip snip]

If you use ALSA you could write a custom .asoundrc file and increase
ALSA's default buffer size, this gives the hardware a longer buffer to
play which may work around the problem. This used to do the trick for me
with the old scheduler with slow machines. Not a fix but if nothing else
works...

Matt

