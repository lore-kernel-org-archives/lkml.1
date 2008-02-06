Return-Path: <linux-kernel-owner+w=401wt.eu-S1757920AbYBFS66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbYBFS66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 13:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYBFS6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 13:58:49 -0500
Received: from relay1.sgi.com ([192.48.171.29]:43310 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751886AbYBFS6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 13:58:48 -0500
Date: Wed, 6 Feb 2008 10:58:47 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Oliver Pinter <oliver.pntr@gmail.com>
cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>, Willy Tarreau <w@1wt.eu>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: {2.6.22.y} quicklists must keep even off node pages on the
 quicklists until the TLB flush has been completed.
In-Reply-To: <6101e8c40802052230l6cc4d708r1fb95ff14363d007@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802061058200.25173@schroedinger.engr.sgi.com>
References: <6101e8c40802051306y24cc7740g4c75508035aaefd@mail.gmail.com> 
 <20080206060256.GA3836@linux.vnet.ibm.com> <6101e8c40802052230l6cc4d708r1fb95ff14363d007@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008, Oliver Pinter wrote:

> I use this, without errors ... but the machine is i386 desktop

The fix for off node frees only applies to NUMA systems. !NUMA has no off 
node pages.

