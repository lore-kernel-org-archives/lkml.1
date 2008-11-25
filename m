Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbYKYLGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbYKYLGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 06:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbYKYLGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 06:06:21 -0500
Received: from bu3sch.de ([62.75.166.246]:39148 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbYKYLGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:06:20 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Yuval Hager <yuval@avramzon.net>
Subject: Re: BCM4312 Fails when xdm is started
Date: Tue, 25 Nov 2008 12:05:49 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>, bcm43xx-dev@lists.berlios.de
References: <200811151801.02369.yuval@avramzon.net> <492AD249.3020309@lwfinger.net> <200811250745.22487.yuval@avramzon.net>
In-Reply-To: <200811250745.22487.yuval@avramzon.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811251205.49929.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 November 2008 06:43:22 Yuval Hager wrote:
> However, I have some few interesting findings. 
> First, this is totally unrelated to b43, but to the PCI. I get the flawed 1's 
> read from lspci even without loading b43.
> 
> I played around with different video drivers and the results are:
> * If using the 'via' driver, I lose the PCIe card immediately upon 
> initialization
> * Using the 'openchrome' (trunk version), It works well in the beginning. 
> After first blanking the register reads are all 1's, and then when the screen 
> is blank I get a different read (some registers are correct, some are wrong), 
> and when the screen is unblanked, I get 0xff's again. Very consistent and 
> predictabe (same read every time).
> * Using the 'vesa' driver I could not recreate the problem. I could not get 
> the screen to blank for some reason, but closing the lid, going on 
> standby/hibernate, restarting X - all didn't matter much to the PCI and the 
> wireless card kept on working.

Ok, then you should report the stuff to the X guys. This is not a b43 problem
and I also don't think it's a kernel problem.

-- 
Greetings Michael.
