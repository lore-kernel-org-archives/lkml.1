Return-Path: <linux-kernel-owner+w=401wt.eu-S1750699AbXCJRy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750699AbXCJRy0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 12:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbXCJRyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 12:54:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:9246 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbXCJRyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 12:54:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=hnmmGDWAdXWphNJ2wId7xSvc3twKcyWl353aLQK4WKZ6tfpYz7Pu/DBbsrg+KhE4O01Og8R+pBeB1t4TYYlEpfEr7sLzQ5LmHfxNaiH+ceyJPH1kaFPobpsmd4JhPs9KkR83BqX96P1b1DG2/yKBU0dqsF4wwzlXbfWhg78i/P0=
Date: Sat, 10 Mar 2007 20:50:58 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: "Make nenuconfig" does not save parameters.
Message-ID: <20070310175058.GA19878@cvg>
References: <20070310160542.21cdb968@localhost> <20070310160614.GB10230@cvg> <Pine.LNX.4.61.0703101724160.8799@yvahk01.tjqt.qr> <20070310194617.2aef1006@localhost> <Pine.LNX.4.61.0703101747530.8799@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0703101747530.8799@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Jan Engelhardt - Sat, Mar 10, 2007 at 05:50:56PM +0100]
| On Mar 10 2007 19:46, Vladimir wrote:
| >> On Mar 10 2007 19:06, Cyrill Gorcunov wrote:
| >> >[Vladimir - Sat, Mar 10, 2007 at 04:05:42PM +0300]
| >> >| Here's the problem:
| >> >|   1. Unpack the kernel sources, run make menuconfig.
| >> >|   2. Mark the necessary options.
| >> >|   3. Pick "Save an alternate configuration file", enter a filename (e.g. /root/kernelcfg)
| >> >|   4. Pick "Exit".
| >> >| ->5. Configurator exits without saving. If type "make bzImage", it builtd all the default
| >> >options.
| >> 
| >> Well, you already saved explicitly and did not make any further 
| >> changes after that, so it won't ask again on exit (perhaps all Office 
| >> Suites do the same). In fact, if you do exactly that, menuconfig 
| >> assumes you do not intend to build a kernel (since you did not save 
| >> to .config).
| >
| >Hm.... Do i have to "Save an alternate configuration file" to ".config" 
| >manually? The configurator used to do that automatically when i pick 
| >"Exit". I think that was reasonable. Anyway, the patch Cyrill sent me 
| >works all right.
| 
| If you make some changes and do not call 'save an alternate config 
| file', it will ask you on exit.
| 
| If you make no changes at all, a .config won't get written - true. But 
| then, the defconfig will be used anyway.
| 
| All is fine.
| 
| 
| Jan

Jan

lets see to the following scenario:

	1) I've taken a pure Linux kernel (no .config at all)
	2) I started menuconfig, made a few changes and saved the file
	to .config1 as alternate
	3) Then I made some additional changes
	4) Then I'm getting out of menuconfig and of course "Save
	configuration..?" question is raising. Ok, I'm selecting
	"Yes" and as result new configuration will be written to the .config
	file. All works as it should be...
	
...but as you mentoined in your message "perhaps all Office Suites do
the same" - no, Office do not the same. The only question I have
(and it could resolve all our problems) - what an alternate config
file is:

	- just a snapshot of a config tree at moment of its writting
	- _working_ file to which configurator should write parameters

your comments?

P.S.

Excuse for poor eng. grammar

		Cyrill

