Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbZKDTiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbZKDTiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757916AbZKDTiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:38:18 -0500
Received: from smtp2.ultrahosting.com ([74.213.174.253]:37443 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757223AbZKDTiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:38:17 -0500
Date: Wed, 4 Nov 2009 14:37:06 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, Ian Campbell <Ian.Campbell@citrix.com>,
       Tejun Heo <tj@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Correct nr_processes() when CPUs have been unplugged
In-Reply-To: <20091104060933.GB6830@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.1.10.0911041434530.7409@V090114053VZO-1>
References: <1257243074.23110.779.camel@zakaz.uk.xensource.com> <20091103160734.GA21362@elte.hu> <alpine.DEB.1.10.0911031324380.32136@V090114053VZO-1> <20091104060933.GB6830@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009, Paul E. McKenney wrote:

> > Cpu hotplug is rarely used (what you listed are rare and unusual cases)
> > and therefore online cpus == possible cpus == present cpus.
>
> Though it is not unusual for "possible cpus" to be quite a bit larger
> than "online cpus"...

The only reason for possible cpus to be larger than online cpus is if you
can actually plugin more processors while the system is running. Typically
the larger possible cpus seems to be some sort of Vendor BIOS screwup
where the vendor advertises how many processors the maximum configuration
of a certain type of hardware would suppport if one would buy that config.

