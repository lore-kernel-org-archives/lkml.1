Return-Path: <linux-kernel-owner+w=401wt.eu-S1757179AbYAFJcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbYAFJcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 04:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbYAFJcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 04:32:13 -0500
Received: from koto.vergenet.net ([210.128.90.7]:52174 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbYAFJcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 04:32:12 -0500
Date: Sun, 6 Jan 2008 18:32:11 +0900
From: Simon Horman <horms@verge.net.au>
To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc: Amos Waterland <apw@us.ibm.com>
Subject: Re: Problems with nfsroot due to ip= cmdline changes
Message-ID: <20080106093211.GB3172@verge.net.au>
References: <20080105165623.GA30987@sci.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080105165623.GA30987@sci.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 06:56:23PM +0200, Ville Syrjälä wrote:
> I recently rebased my kernel tree and discovered that my nfsroot setup
> no longer worked. Here's the relevat part of my cmdline:
> 
> ip=192.168.2.200:192.168.2.185:192.168.2.1:255.255.255.0::eth0:off nfsroot=192.168.2.185:/my_nfsroot,v3,tcp root=/dev/nfs
> 
> I discovered that now I had to change the autoconfiguration option to
> "on" in order to make nfsroot work. I only want to specify the IP
> address manually so I don't really want autoconfiguration. The current
> code works since it will not try autoconfiguration when all options are
> specified manually but the current behaviour does not really match the
> documentation ie. now the autoconf parameter can disable the whole IP
> configuration step even though the documentation says it will only
> disable autoconfiguration.
> 
> Looks like these are the relevant commits:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a6c05c3d064dbb83be88cba3189beb5db9d2dfc3
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9cecd07c3f7a818a5865daad8cb5be408508dc99

Hi,

I believe that this patch from Amos Waterland resolves the problem that
you are seeing: http://lkml.org/lkml/2008/1/5/247

-- 
Horms

