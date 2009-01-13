Return-Path: <linux-kernel-owner+w=401wt.eu-S1759116AbZAMFsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116AbZAMFsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 00:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbZAMFsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 00:48:09 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53630 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668AbZAMFsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 00:48:08 -0500
Date: Tue, 13 Jan 2009 10:38:31 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH -mm 0/6] kprobes: Per-probe disabling support
Message-ID: <20090113050831.GF12392@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <496BF48F.2030300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496BF48F.2030300@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 08:55:27PM -0500, Masami Hiramatsu wrote:
> Hi,
> 
> Currently, kprobes can disable all probes at once, but can't disable it
> individually (not unregister, just disable an kprobe, because unregistering
> needs to wait for scheduler synchronization).
> These patches introduce APIs for on-the-fly per-probe disabling and
> re-enabling by dis-arming/re-arming its breakpoint instruction.
> 
> These patches can be applied on the latest -mm tree including my previous
> bugfix patch (http://lkml.org/lkml/2009/1/5/472).
> 
> You can download a test of this feature from here:
> http://sources.redhat.com/bugzilla/attachment.cgi?id=3082&action=view
> 
> Thank you,
> 
>  Documentation/kprobes.txt |   38 +++++-
>  include/linux/kprobes.h   |   51 +++++++-
>  kernel/kprobes.c          |  281 ++++++++++++++++++++++++++++++++--------------
>  3 files changed, 279 insertions(+), 91 deletions(-)

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

...for the patchset.

Thanks for the work Masami. We'll need to allow this set to cook in
-mm/next for a few weeks before it goes upstream.

Ananth
