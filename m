Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbZDWA7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbZDWA7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 20:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbZDWA7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 20:59:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:33413 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbZDWA7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 20:59:32 -0400
Message-ID: <49EFAF4D.2090509@suse.de>
Date: Thu, 23 Apr 2009 08:59:09 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, tiwai@suse.de,
       fuse-devel@lists.sourceforge.net
Subject: Re: [ANNOUNCE] OSS Proxy 1.2 using CUSE
References: <48B6F711.1040604@kernel.org> <49E3F91E.4000801@suse.de> <E1Lwian-0004pq-8P@pomaz-ex.szeredi.hu>
In-Reply-To: <E1Lwian-0004pq-8P@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Miklos.

Miklos Szeredi wrote:
> Xmms with the OSS output plugin doesn't really work.  It plays like 10
> times too fast and the output is not really recognizable.

Hmm...

> This is the debug output of osspd:
> 
> osspd: OSS Proxy v1.2 (C) 2008-2009 by Tejun Heo <teheo@suse.de>
> osspd: Creating dsp (14:3), adsp (14:12), mixer (14:0)
> osspd DBG0: CREATE mixer(12799)
> osspd DBG0: S[1/16744] CREATE slave=16745 /store/git/ossp/ossp-padsp
> osspd DBG0: S[1/16744]   client=16744 cmd=7:8 notify=9:10
> ossp-padsp[mszeredi:16745] DBG0: requested frag_size (4096) is smaller than mini
> mum (4412)
> ossp-padsp[mszeredi:16745] DBG0: CREATE PLAY s16le 2ch 44100Hz fsz=4412:25
> ossp-padsp[mszeredi:16745] DBG0:   tlen=131072:743 max=139896:793 pre=8192:46
> ossp-padsp[mszeredi:16745] DBG0:   u_sd=0 u_fsz=4096:23 u_maxf=32
> osspd DBG0: S[1/16744] volume set=-1/-1:-1/-1 get=63/63:0/0
> ossp-padsp[mszeredi:16745] DBG0: PLAY stream underrun
> ossp-padsp[mszeredi:16745] DBG0: PLAY stream underrun
> ossp-padsp[mszeredi:16745] DBG0: PLAY stream underrun
> ossp-padsp[mszeredi:16745] DBG0: PLAY stream underrun
> ossp-padsp[mszeredi:16745] DBG0: PLAY stream underrun
> ossp-padsp[mszeredi:16745] DBG0: PLAY stream underrun

Hmmm..

> [...message repeated zillion times]
> 
> I guess this has something to do with the too small frag size, but
> couldn't figure out how all this works in prepare_streams() and
> padsp_write().

Yeah, it's a bit convoluted.  I'll try xmms.

Thanks.

-- 
tejun
