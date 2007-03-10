Return-Path: <linux-kernel-owner+w=401wt.eu-S933482AbXCJQjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482AbXCJQjX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 11:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933484AbXCJQjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 11:39:23 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:47879 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933482AbXCJQjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 11:39:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=sf+A/hkFLHCz4KMdY/eCZIXRrtkTdKmByV6W8Hz5eYXORghDzqWRHs62iW9J8hgSoMLoV+tMCxtuFw/p1wjpHmp77KxEcK19hrdxGl4VEXY/97SCb+xvL28cuAb9pzRjga9WIf/DgpAGSm2SCnz08YgtqqfN6Dn9LRtv/EsVHTc=
Date: Sat, 10 Mar 2007 19:35:57 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: "Make nenuconfig" does not save parameters.
Message-ID: <20070310163557.GC10230@cvg>
References: <20070310160542.21cdb968@localhost> <20070310160614.GB10230@cvg> <Pine.LNX.4.61.0703101724160.8799@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0703101724160.8799@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Jan Engelhardt - Sat, Mar 10, 2007 at 05:26:03PM +0100]
| 
| On Mar 10 2007 19:06, Cyrill Gorcunov wrote:
| >[Vladimir - Sat, Mar 10, 2007 at 04:05:42PM +0300]
| >| Here's the problem:
| >|   1. Unpack the kernel sources, run make menuconfig.
| >|   2. Mark the necessary options.
| >|   3. Pick "Save an alternate configuration file", enter a filename (e.g. /root/kernelcfg)
| >|   4. Pick "Exit".
| >| ->5. Configurator exits without saving. If type "make bzImage", it builtd all the default options.
| 
| Well, you already saved explicitly and did not make any further changes
| after that, so it won't ask again on exit (perhaps all Office Suites do
| the same). In fact, if you do exactly that, menuconfig assumes you do not
| intend to build a kernel (since you did not save to .config).
| 
| 
| Jan
| -- 
| 

Hi, Jan

so you think that is a normal behaviour? I mean sould we leave all as
it is?

		Cyrill

