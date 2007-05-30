Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbXE3Ryr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbXE3Ryr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbXE3Ryj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:54:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbXE3Ryi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:54:38 -0400
Date: Wed, 30 May 2007 13:54:06 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH -mm] 1/2: MMCONFIG: validate against ACPI motherboard resources
Message-ID: <20070530175406.GE5302@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Robert Hancock <hancockr@shaw.ca>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>
References: <465CF794.1070406@shaw.ca> <alpine.LFD.0.98.0705292125511.26602@woody.linux-foundation.org> <465D8BA1.1080800@shaw.ca> <alpine.LFD.0.98.0705300804140.26602@woody.linux-foundation.org> <20070530172331.GB2794@redhat.com> <alpine.LFD.0.98.0705301034320.26602@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705301034320.26602@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 10:37:49AM -0700, Linus Torvalds wrote:

 > Although in this case it was actually not a Linux MUA:
 > 
 > 	User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
 > 
 > but I didn't want to embarrass Robert publicly before you brought up the 
 > issue of operating systems ;)

Oh well, there's no accounting for taste ;-)

 > Your procmail filter looks somewhat broken, btw. It will trigger on things 
 > that aren't headers, and it will potentially _not_ trigger on headers (ie 
 > if they are line continuations). But I guess it works well enough in 
 > practice.

Yeah, now that I look again, it actually missed on Robert's message because
it isn't case-insensitive.  It's far from perfect.

	Dave

-- 
http://www.codemonkey.org.uk
