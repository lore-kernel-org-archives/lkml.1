Return-Path: <linux-kernel-owner+w=401wt.eu-S1756422AbZKMQZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbZKMQZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 11:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311AbZKMQZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 11:25:29 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:59564 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756272AbZKMQZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 11:25:26 -0500
Date: Fri, 13 Nov 2009 16:25:31 +0000
To: =?utf-8?Q?P=C3=A1draig?= Brady <P@draigBrady.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Matteo Croce <technoboy85@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091113162531.GW15157@caffeine.csclub.uwaterloo.ca>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> <20091003072127.GC21407@elte.hu> <40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com> <4AF4526B.4060101@zytor.com> <40101cc30911081042n93e268bs66b9436a0174a19a@mail.gmail.com> <20091109201608.GD15159@caffeine.csclub.uwaterloo.ca> <4AF886D4.1080108@zytor.com> <20091109212333.GE15159@caffeine.csclub.uwaterloo.ca> <4AFD6042.1030105@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AFD6042.1030105@draigBrady.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 01:33:54PM +0000, Pádraig Brady wrote:
> Lennart Sorensen wrote:
> > Which would be mroe indication that the Geode LX may in fact be a K6
> > based CPU design.  The Geode NX is very clearly an Athlon (K7) and AMD
> > has never even tried to hide that.  They have never said what the LX is
> > based on, other than it isn't based on the GX (fortunately, that thing
> > was a buggy piece of crap).
> 
> When looking this up for http://www.pixelbeat.org/scripts/gcccpuopt
> I determined that gcc --march=geode is for the LX which is
> K6 + 3dnowext. Note gcc has no way currently of explicitly selecting 3dnowext.

If that is the case then geode is an awful name choice given the GX,
LX and NX all have vastly different features and requirements, yet are
all geodes.

-- 
Len Sorensen
