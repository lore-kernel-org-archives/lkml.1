Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbYKTRkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbYKTRkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 12:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756162AbYKTRkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 12:40:24 -0500
Received: from styx.suse.cz ([82.119.242.94]:39695 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756169AbYKTRkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 12:40:23 -0500
Date: Thu, 20 Nov 2008 18:40:21 +0100
From: Michal Hocko <mhocko@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: ipw3945-devel@lists.sourceforge.net, reinette.chatre@intel.com,
       yi.zhu@intel.com, linux-wireless@vger.kernel.org
Subject: Re: BUG: scheduling while atomic: iwl3945/0/3680/0x00000002 during
	resume from suspend
Message-ID: <20081120174021.GA6518@dhcp35.suse.cz>
References: <20081109141412.GA5858@dhcp35.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081109141412.GA5858@dhcp35.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 09-11-08 15:14:12, Michal Hocko wrote:
> Hi,
> 
> I have noticed BUG condition (%subj) during resume from suspend (see
> attached dmesg from the resume start) if wireless interface is up
> during suspend to RAM (BUG doesn't occure when interface is not
> configured during suspend).
> 
> Notebook seems to survive this problem without any noticeable problems
> (wifi is working).
> 
> I am using recent Linus git tree (75fa67706cce5272bcfc51ed646f2da21f3bdb6e) 
> with the config attached but the same problem occurs on the 2.6.28-rc2
> and 2.6.27 kernels too (see logs). Traces are not the same, but they are
> very similar.

JFYI: I don't this problem with 7f0f598a0069d1ab072375965a4b69137233169c
anymore

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
