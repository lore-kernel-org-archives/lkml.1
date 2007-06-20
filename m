Return-Path: <linux-kernel-owner+w=401wt.eu-S1760561AbXFTMaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760561AbXFTMaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 08:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbXFTMaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 08:30:05 -0400
Received: from ns.suse.de ([195.135.220.2]:38670 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865AbXFTMaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 08:30:04 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [patches] [PATCH for 2.6.22] [10/10] x86_64: fix link warningbetween for .text and .init.text
Date: Wed, 20 Jun 2007 14:30:00 +0200
User-Agent: KMail/1.9.6
Cc: yhlu.kernel@gmail.com, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       patches@x86-64.org
References: <200706201223.443613000@suse.de> <20070620102339.2812014ACF@wotan.suse.de> <46793389.76E4.0078.0@novell.com>
In-Reply-To: <46793389.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706201430.00986.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 June 2007 14:02:49 Jan Beulich wrote:
> This is the right way I think. With mtrr_bp_init being __init, get_mtrr_state
> can then also be __init, making the other two changes unnecessary. I had
> submitted a patch to that effect about a week ago. Beyond that patch, as
> I now looked at this again, it would seem to me that print_fixed can then in
> fact also be __init (rather than being __cpuinit).

Possible. I'm inclined to just leave it as it is now, don't really
care about some more or less bytes in the init section.

This whole new __init checking is a constant annoyance; nearly
all of these warnings are false positives and it is actually
CONFIG dependent.

-Andi

