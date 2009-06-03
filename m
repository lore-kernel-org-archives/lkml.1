Return-Path: <linux-kernel-owner+w=401wt.eu-S1753712AbZFCACa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbZFCACa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 20:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbZFCACW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 20:02:22 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:40007 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbZFCACV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 20:02:21 -0400
MIME-Version: 1.0
Message-ID: <793c2ffe-16d3-4e6c-9cd2-32fa089e46a3@default>
Date: Tue, 2 Jun 2009 17:00:21 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: George Dunlap <george.dunlap@eu.citrix.com>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, avi@redhat.com,
       xen-devel@lists.xensource.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, Keir Fraser <Keir.Fraser@eu.citrix.com>,
       torvalds@linux-foundation.org, gregkh@suse.de, kurt.hackel@oracle.com,
       Ian Pratt <Ian.Pratt@eu.citrix.com>, xen-users@lists.xensource.com,
       ksrinivasan <ksrinivasan@novell.com>, EAnderson@novell.com,
       wimcoekaerts@wimmekes.net, Stephen Spector <stephen.spector@citrix.com>,
       jens.axboe@oracle.com, npiggin@suse.de
Subject: RE: Merge Xen (the hypervisor) into Linux
In-Reply-To: <20090602232843.GA6577@elte.hu>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1 (304090) [OL 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.4A25BD1D.0078:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That sound you heard was 10000 xen-users@lists.xensource.com
all having heart attacks at once.

Need I say more.

> -----Original Message-----
> From: Ingo Molnar [mailto:mingo@elte.hu]
> Sent: Tuesday, June 02, 2009 5:29 PM
> To: Steven Rostedt
> Cc: George Dunlap; David Miller; jeremy@goop.org; Dan Magenheimer;
> avi@redhat.com; xen-devel@lists.xensource.com; x86@kernel.org;
> linux-kernel@vger.kernel.org; Keir Fraser;
> torvalds@linux-foundation.org; gregkh@suse.de; Kurt Hackel; Ian Pratt;
> xen-users@lists.xensource.com; ksrinivasan; EAnderson@novell.com;
> wimcoekaerts@wimmekes.net; Stephen Spector; Jens Axboe; 
> npiggin@suse.de
> Subject: Merge Xen (the hypervisor) into Linux
> 
> 
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Now here's a crazy solution. Merge the Xen hypervisor into Linux 
> > ;-)
> 
> That's not that crazy - it's the right technical solution if DOM0 is 
> desired for upstream. From what i've seen in DOM0 land the incestous 
> dependencies are really only long-term manageable if the whole thing 
> is in a single tree.
> 
> A lot of Xen legacies could be dropped: the crazy ring1 hack on 
> 32-bit, the various wide interfaces to make pure-software 
> virtualization limp along. All major CPUs shipped with hardware 
> virtualization support in the past 2-3 years, so the availability of 
> VMX and SVM can be taken for granted for such a project.
> 
> That cuts down on a fair amount of crap. A lot of code on the Linux 
> side could be reused, and a pure CONFIG_PCI=y (all other things 
> disabled) would provide a "slim hypervisor" instance with a very 
> small and concentrated code base. (That 'slim hypervisor' might even 
> be built with CONFIG_NOMMU.)
> 
> That way dom0 would be a natural extension: a minimal interface 
> between Linux-Xen-minimal and the dom0 guest instance.
> 
> It's a sane technical model IMO, and makes dom0 a lot more 
> palatable. Having in-tree competition to KVM would also obviously be 
> good to Linux in general.
> 
> 	Ingo
>
