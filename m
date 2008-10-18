Return-Path: <linux-kernel-owner+w=401wt.eu-S1752030AbYJROtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbYJROtP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 10:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYJROs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 10:48:59 -0400
Received: from sandeen.net ([209.173.210.139]:25084 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbYJROs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 10:48:59 -0400
Message-ID: <48F9F759.5070602@sandeen.net>
Date: Sat, 18 Oct 2008 09:48:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Martin Michlmayr <tbm@cyrius.com>
CC: Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org,
       debian-arm@lists.debian.org, xfs@oss.sgi.com
Subject: Re: XFS filesystem corruption on the arm(el) architecture
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net> <20081016212500.GA27228@deprecation.cyrius.com> <48F7BC9F.4080909@sandeen.net> <20081017070109.GA30726@deprecation.cyrius.com> <48F89E0F.6030307@sandeen.net> <20081018085752.GS25834@deprecation.cyrius.com>
In-Reply-To: <20081018085752.GS25834@deprecation.cyrius.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Michlmayr wrote:
> * Eric Sandeen <sandeen@sandeen.net> [2008-10-17 09:15]:

>> Do you know what cachepolicy you're booted with?  If it's writeallocate,
>> you might try cachepolicy=writeback, otherwise try cachepolicy=uncached
>> (which will be horribly slow) and see if the problem goes away or not;
>> it'd be a clue.
> 
> I just tried with cachepolicy=writeback and cachepolicy=uncached but I
> get the same problem.

Oh, wow.  This sounds like a new problem then; not a cache problem, and
not an alignment problem...  hrm.  I'll try to think of something else
to try.

Thanks,
-Eric

