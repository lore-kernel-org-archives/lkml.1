Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbYJ1L03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbYJ1L03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 07:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYJ1L0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 07:26:22 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:48572 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbYJ1L0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 07:26:21 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2008 07:26:20 EDT
Message-ID: <4906F54A.7020909@aitel.hist.no>
Date: Tue, 28 Oct 2008 12:19:38 +0100
From: Helge Hafting <helge.hafting@aitel.hist.no>
Organization: HiST
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc2 i/o error on /dev/ttyUSB0
References: <alpine.LFD.2.00.0810261221350.3386@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810261221350.3386@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have gps unit connected via USB-serial (pl2303).
This does not work with 2.6.28-rc2

udev creates devices as usual, but /dev/ttyUSB0 fail.
cat /dev/ttyUSB0 gives i/o errors, for example.

gpsd try several times, and then fall back on opening
in read-only mode. This works, but gpsd doesn't actually
get any data at all from the unit.

The pc is a core2duo laptop, using a 64-bit smp kernel.

2.6.27 is fine. I skipped 2.6.28-rc1 due to known breakage.
I can test it if that might help.

Helge Hafting
