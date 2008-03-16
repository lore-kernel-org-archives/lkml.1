Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbYCPXTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbYCPXTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 19:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYCPXTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 19:19:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbYCPXTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:19:35 -0400
From: Neil Brown <neilb@suse.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Date: Mon, 17 Mar 2008 10:19:20 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18397.43768.705353.514972@notabene.brown>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: Oops in NFSv4 server in 2.6.23.17
In-Reply-To: message from J. Bruce Fields on Friday March 14
References: <20080312122550.GB8141@ics.muni.cz>
	<20080312160007.GA10015@fieldses.org>
	<20080313143631.GH27873@ics.muni.cz>
	<20080314181413.GF2119@fieldses.org>
	<20080314193350.GK2119@fieldses.org>
	<20080314195303.GA4390@ics.muni.cz>
	<20080314200510.GL2119@fieldses.org>
	<20080314234205.GO2119@fieldses.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday March 14, bfields@fieldses.org wrote:
> On Fri, Mar 14, 2008 at 04:05:10PM -0400, bfields wrote:
> > I find that a little contorted.  So I'll go ahead and submit this small
> > patch to 2.6.25 and stable now (I have since managed to reproduce what I
> > believe is your bug, though my symptoms were a little different), and
> > then submit to 2.6.26 some cleanup which makes this more understandable,
> 
> Here's an attempt.  We could break up fh_verify even more, though.--b.

Looks like a good attempt.

My only suggestion would be to put a comment at the top of
nfsd_set_fh_dentry explaining what it does and who calls it.

It's long past time that code had some spring cleaning !!

Thanks,
NeilBrown
