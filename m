Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbYABUsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbYABUsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbYABUso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:48:44 -0500
Received: from relay2.sgi.com ([192.48.171.30]:34954 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753336AbYABUsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:48:43 -0500
Date: Wed, 2 Jan 2008 12:48:43 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, htejun@gmail.com,
       gregkh@suse.de, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, maneesh@linux.vnet.ibm.com,
       lkml <linux-kernel@vger.kernel.org>, stable@kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22-stable causes oomkiller to be invoked
In-Reply-To: <20071230140116.GC21106@elte.hu>
Message-ID: <Pine.LNX.4.64.0801021247270.21526@schroedinger.engr.sgi.com>
References: <20071214150533.aa30efd4.akpm@linux-foundation.org>
 <20071215035200.GA22082@linux.vnet.ibm.com> <20071214220030.325f82b8.akpm@linux-foundation.org>
 <20071215104434.GA26325@linux.vnet.ibm.com> <20071217045904.GB31386@linux.vnet.ibm.com>
 <Pine.LNX.4.64.0712171143280.12871@schroedinger.engr.sgi.com>
 <20071217120720.e078194b.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0712171222470.29500@schroedinger.engr.sgi.com>
 <20071221044508.GA11996@linux.vnet.ibm.com>
 <Pine.LNX.4.64.0712261258050.16862@schroedinger.engr.sgi.com>
 <20071230140116.GC21106@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Dec 2007, Ingo Molnar wrote:

> so we still dont seem to understand the failure mode well enough. This 
> also looks like a quite dangerous change so late in the v2.6.24 cycle. 
> Does it really fix the OOM? If yes, why exactly?

Not exactly sure. I suspect that there is some memory corruption. See my 
earlier post from today. I do not see this issue on my system. So it must 
be particular to a certain config.
