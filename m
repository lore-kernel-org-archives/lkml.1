Return-Path: <linux-kernel-owner+w=401wt.eu-S937340AbXGSOqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937340AbXGSOqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbXGSOqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:46:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbXGSOqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:46:38 -0400
Date: Thu, 19 Jul 2007 10:46:31 -0400
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: wli@holomorphy.com, lkml@rtr.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for review] [7/48] i386: divorce CONFIG_X86_PAE from
	CONFIG_HIGHMEM64G
Message-ID: <20070719144631.GA14938@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Andi Kleen <ak@suse.de>,
	wli@holomorphy.com, lkml@rtr.ca, linux-kernel@vger.kernel.org
References: <20070719348.540885000@suse.de> <20070719134836.0C54214E6E@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719134836.0C54214E6E@wotan.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 03:48:36PM +0200, Andi Kleen wrote:
 
 > Some users may want NX
 > or expanded swapspace support without the overhead or instability of
 > highmem. 

NX is still going to need the larger PTEs, so I don't see how this
change removes any 'overhead' or potential 'instability'.
I'm not necessarily disagreeing with the change, but this part
of the changelog seems to be false advertising.

	Dave

-- 
http://www.codemonkey.org.uk
