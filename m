Return-Path: <linux-kernel-owner+w=401wt.eu-S1752100AbXDCMN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbXDCMN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 08:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbXDCMN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 08:13:59 -0400
Received: from nikam-dmz.ms.mff.cuni.cz ([195.113.20.16]:53785 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752100AbXDCMN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 08:13:58 -0400
X-Greylist: delayed 1949 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Apr 2007 08:13:58 EDT
Date: Tue, 3 Apr 2007 13:41:27 +0200
From: Martin Mares <mj@ucw.cz>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Paul LeoNerd Evans <leonerd@leonerd.org.uk>
Subject: Re: [PATCH] vt: Do not clear UTF when resetting console
Message-ID: <mj+md-20070403.114037.27180.nikam@ucw.cz>
References: <46110F88.5040905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46110F88.5040905@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> Resetting the console, either by ANSI escape sequences or by the reset utility,
> will drop the console back to legacy (non-UTF-8) mode.

Yes, and as far as I understand the logic behind these escape sequences,
it's the intended behavior, not a bug.

The escape sequence for terminal reset should reset as much as possible,
I see no reason for making an exception for the UTF-8 mode.

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
Lottery -- a tax on people who can't do math.
