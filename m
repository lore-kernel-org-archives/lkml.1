Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbZKDToW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbZKDToW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758030AbZKDToV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:44:21 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53549 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758031AbZKDToT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:44:19 -0500
Date: Wed, 4 Nov 2009 11:44:20 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ian Campbell <Ian.Campbell@citrix.com>,
       Tejun Heo <tj@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Correct nr_processes() when CPUs have been unplugged
Message-ID: <20091104194420.GG6736@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1257243074.23110.779.camel@zakaz.uk.xensource.com> <20091103160734.GA21362@elte.hu> <alpine.DEB.1.10.0911031324380.32136@V090114053VZO-1> <20091104060933.GB6830@linux.vnet.ibm.com> <alpine.DEB.1.10.0911041434530.7409@V090114053VZO-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0911041434530.7409@V090114053VZO-1>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 02:37:06PM -0500, Christoph Lameter wrote:
> On Tue, 3 Nov 2009, Paul E. McKenney wrote:
> 
> > > Cpu hotplug is rarely used (what you listed are rare and unusual cases)
> > > and therefore online cpus == possible cpus == present cpus.
> >
> > Though it is not unusual for "possible cpus" to be quite a bit larger
> > than "online cpus"...
> 
> The only reason for possible cpus to be larger than online cpus is if you
> can actually plugin more processors while the system is running. Typically
> the larger possible cpus seems to be some sort of Vendor BIOS screwup
> where the vendor advertises how many processors the maximum configuration
> of a certain type of hardware would suppport if one would buy that config.

Or if you are running as a guest OS on top of some sort of hypervisor.

							Thanx, Paul
