Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbYDGVK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbYDGVK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbYDGVKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:10:49 -0400
Received: from outbound-mail-150.bluehost.com ([67.222.38.40]:41512 "HELO
	outbound-mail-150.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750960AbYDGVKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:10:48 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] x86: create array based interface to change page attribute
Date: Mon, 7 Apr 2008 14:09:07 -0700
User-Agent: KMail/1.9.9
Cc: Thomas =?iso-8859-1?q?Hellstr=F6m?= <thomas@tungstengraphics.com>,
       Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <47FA8A69.6080402@linux.intel.com> <200804071402.21548.jbarnes@virtuousgeek.org>
In-Reply-To: <200804071402.21548.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804071409.08109.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 07, 2008 2:02 pm Jesse Barnes wrote:
> On Monday, April 07, 2008 1:56 pm Arjan van de Ven wrote:
> > Jesse Barnes wrote:
> > > Yeah, they're ioremapped now, but that's a problem since with the PAT
> > > patches they'll be mapped hard UC (right now it just happens to work).
> >
> > clearly this needs to use ioremap_wc(), I was assuming nothing else....
> > (code mapping things uncached and then frobbing the MTRR's underneath
> > really shouldn't be allowed to live from 2.6.26 and forward. Esp for the
> > 3D drivers we KNOW that we want _wc so that is a clear case of just
> > fixing the code to do the right thing)
>
> Totally agreed, the AGP code needs to be specific about what it wants...

Err DRM code (but AGP does too).

Jesse
