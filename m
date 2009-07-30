Return-Path: <linux-kernel-owner+w=401wt.eu-S1752075AbZG3GXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbZG3GXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 02:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbZG3GXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 02:23:15 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:37108 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbZG3GXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 02:23:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=bpVyBEJWMvvq0XD+L48wW4vTmnqSPyxH0tln0pMVtugJQ6sESytKNnMo5aUFW1+NdA
         WiZwszEzSsDc2yvJh6GRbMrPQeLW27U7QOU+yt3AXYXRvpPssSxyICxa/dI5vtfk3R1x
         lQ12nHFK6VRRCotImRuGJBCr3FxrcB0ZAHLPs=
Date: Thu, 30 Jul 2009 08:23:09 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Borislav Petkov <borislav.petkov@amd.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: linux-next: manual merge of the edac-amd tree with the rr tree
Message-ID: <20090730062309.GA15057@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Borislav Petkov <borislav.petkov@amd.com>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Rusty Russell <rusty@rustcorp.com.au>,
	Andreas Herrmann <andreas.herrmann3@amd.com>
References: <20090730154150.d4c326b5.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090730154150.d4c326b5.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 03:41:50PM +1000, Stephen Rothwell wrote:
> Hi Borislav,
> 
> Today's linux-next merge of the edac-amd tree got a conflict in
> include/linux/topology.h between commit
> 11c0109a8c24b27fd6eff8c2c0ddca598675212d
> ("cpumask:remove-topology_core_siblings-and-topology_thread_siblings-core")
> from the rr tree and commit 86aebc88b40884510c914ad71e81c8536a15052e
> ("topology: introduce cpu_node information for multi-node processors")
> from the edac-amd tree.
> 
> The latter adds topology_cpu_node_siblings() which is not needed (the
> former makes it clear that the _cpumask versions of these should be used
> instead).  I fixed it up and can carry the fix as necessary.

Hi Stephen,

thanks for fixing that. Yep, the topology patches in the edac tree are
not final yet, I've added them to the mix only because edac depends on
the node_id functionality. I'll fix them up later against the rr stuff.

-- 
Regards/Gruss,
    Boris.
