Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbYHDKBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbYHDKBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 06:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbYHDKA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 06:00:58 -0400
Received: from jenny.ondioline.org ([66.220.1.122]:35534 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbYHDKA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:00:57 -0400
From: Paul Collins <paul@burly.ondioline.org>
To: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linuxppc-dev@ozlabs.org,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
Subject: Re: nfsd, v4: oops in find_acceptable_alias, ppc32 Linux, post-2.6.27-rc1
References: <87tze38vzt.fsf@burly.wgtn.ondioline.org>
	<20080802184554.GB715@fieldses.org>
	<87abfvm4cc.fsf@burly.wgtn.ondioline.org>
	<877iayy4qc.fsf@burly.wgtn.ondioline.org>
	<18581.40960.737792.454035@notabene.brown>
	<87r696l1yo.fsf@burly.wgtn.ondioline.org>
	<18582.32935.501672.689845@notabene.brown>
	<87fxpll5zq.fsf@burly.wgtn.ondioline.org>
Date: Mon, 04 Aug 2008 22:00:55 +1200
In-Reply-To: <87fxpll5zq.fsf@burly.wgtn.ondioline.org> (Paul Collins's message
	of "Mon, 04 Aug 2008 17:11:05 +1200")
Message-ID: <87y73dcd60.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Collins <paul@burly.ondioline.org> writes:

> Neil Brown <neilb@suse.de> writes:
>> Could you try removing the 'static' declaration for nfsd_acceptable
>> and recompile?
>> Or maybe try a different compiler?
>
> I will give these a try this evening.

I built myself a nice new cross compiler:

        powerpc-linux-gnu-gcc-4.1 (GCC) 4.1.3 20080623 (prerelease) (Debian 4.1.2-23)

and rebuilt 94ad374a0751f40d25e22e036c37f7263569d24c.  Running that on
the server and 2.6.26 on the client, I got yet another Oops.  This one
locked the machine up pretty good, so all I have is a picture:

http://ondioline.org/~paul/DSCN1608.JPG

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
