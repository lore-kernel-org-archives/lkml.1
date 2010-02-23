Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab0BWRFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 12:05:30 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:62511 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab0BWRF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 12:05:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rHnfqbTuV/SFmwVjtlQ3R0G/VyYbo+rEGlJcd34UYLWAyQKMkLaMqDOxsfPOKJZUtN
         23BQ/Eialqim0A4nbR9EIFuxMC8z+0OwHu6AOHKL4Z14v7yi2j0Tz8kOqt/R/w5eNoAs
         wxD2+NspZnZuMTlyzOo2TIgSJ7a1H9Z1yp2pU=
Date: Tue, 23 Feb 2010 18:05:20 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip v10 0/9] kprobes: Kprobes jump optimization support
Message-ID: <20100223170508.GB5357@nowhere>
References: <20100218221247.19637.80088.stgit@dhcp-100-2-132.bos.redhat.com> <4B830FDB.7010202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B830FDB.7010202@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 06:14:35PM -0500, Masami Hiramatsu wrote:
> Masami Hiramatsu wrote:
> > Hi Ingo,
> > 
> > Here are the patchset of the kprobes jump optimization v10
> > (a.k.a. Djprobe). This version just updated a document,
> > and applicable for 2.6.33-rc8-tip.
> 
> BTW, this optimization is automatically done in kprobes.
> (no other tools/changes are required for it)
> This means all users including perf-probe have a benefit
> from this feature just by configuring CONFIG_OPTPROBES=y :)
> So it's a part of perf-probe/kprobe-tracer enhancement, IMHO.
> 
> Thank you,


Yep. I guess we can give it a try for 2.6.34.
Ingo?

