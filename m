Return-Path: <linux-kernel-owner+w=401wt.eu-S1760951AbXK1Wkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951AbXK1Wkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757634AbXK1WkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:40:24 -0500
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:43941 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579AbXK1WkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:40:22 -0500
Date: Thu, 29 Nov 2007 09:40:20 +1100
To: Frederik Himpe <fhimpe@telenet.be>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.24-rc3-git3: usb hardware interrupts using 25% of CPU time
Message-ID: <20071128224020.GE24243@bakeyournoodle.com>
References: <pan.2007.11.28.22.33.18@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <pan.2007.11.28.22.33.18@telenet.be>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 10:33:18PM +0000, Frederik Himpe wrote:

> I installed Linux 2.6.24-rc3-git3 on a PPC based Apple Powerbook G4 
> system. Now with top I see that over 20% of CPU time is used by hardware 
> interrupts. Looking at /proc/interrupts, the number in the row 
> ohci_hcd:usb1 is rising very quickly:

Hi Frederik,
	Thanks for the report.  We suspect that this is an accounting
problem introduced when powerpc enabled NO_HZ and highres timers.
Fortunatley from the testing we've done it doens't actually look like
the time is being spent in hardware interupts, just accounted for there.
 
Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

