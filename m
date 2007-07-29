Return-Path: <linux-kernel-owner+w=401wt.eu-S937454AbXG2Xej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937454AbXG2Xej (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 19:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935237AbXG2Xeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 19:34:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934431AbXG2Xea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 19:34:30 -0400
Date: Sun, 29 Jul 2007 19:34:28 -0400
From: Dave Jones <davej@redhat.com>
To: "Berck E. Nash" <flyboy@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: cpufreq scaling appears not to work on overclocked systems
Message-ID: <20070729233428.GA405@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Berck E. Nash" <flyboy@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <46AD03BD.7040203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AD03BD.7040203@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 03:16:45PM -0600, Berck E. Nash wrote:

 > I'm running a Core2 Duo 1.86GHz overclocked to 2.56GHz.  Everything is
 > normal with cpufreq scaling disabled.  With cpufreq scaling enabled in
 > the kernel, using any governor, /proc/cpuinfo indicates a maximum of the
 > rated frequency rather than the actual frequency.

FAQ.
The BIOS contains hard coded tables of frequencies.
Just because you changed the clocks on which those tables
are based doesn't mean the tables will change.

Not a bug.

	Dave

-- 
http://www.codemonkey.org.uk
