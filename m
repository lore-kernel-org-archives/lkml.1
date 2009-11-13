Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbZKMNkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbZKMNkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 08:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZKMNkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 08:40:41 -0500
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:19256 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751558AbZKMNkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 08:40:41 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Nov 2009 08:40:40 EST
Message-ID: <4AFD6042.1030105@draigBrady.com>
Date: Fri, 13 Nov 2009 13:33:54 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: "H. Peter Anvin" <hpa@zytor.com>, Matteo Croce <technoboy85@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> <20091003072127.GC21407@elte.hu> <40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com> <4AF4526B.4060101@zytor.com> <40101cc30911081042n93e268bs66b9436a0174a19a@mail.gmail.com> <20091109201608.GD15159@caffeine.csclub.uwaterloo.ca> <4AF886D4.1080108@zytor.com> <20091109212333.GE15159@caffeine.csclub.uwaterloo.ca>
In-Reply-To: <20091109212333.GE15159@caffeine.csclub.uwaterloo.ca>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> Which would be mroe indication that the Geode LX may in fact be a K6
> based CPU design.  The Geode NX is very clearly an Athlon (K7) and AMD
> has never even tried to hide that.  They have never said what the LX is
> based on, other than it isn't based on the GX (fortunately, that thing
> was a buggy piece of crap).

When looking this up for http://www.pixelbeat.org/scripts/gcccpuopt
I determined that gcc --march=geode is for the LX which is
K6 + 3dnowext. Note gcc has no way currently of explicitly selecting 3dnowext.

cheers,
Pádraig.
