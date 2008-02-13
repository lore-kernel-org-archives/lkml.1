Return-Path: <linux-kernel-owner+w=401wt.eu-S1763272AbYBMOQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763272AbYBMOQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 09:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759459AbYBMOPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 09:15:25 -0500
Received: from pat.uio.no ([129.240.10.15]:45524 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763469AbYBMOPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 09:15:23 -0500
Subject: Re: Upgrade to 2.6.24 breaks NFS service
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87lk5pjkro.fsf@hades.wkstn.nix>
References: <87lk5pjkro.fsf@hades.wkstn.nix>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 09:15:19 -0500
Message-Id: <1202912119.11904.14.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 31E4ED9689316D062FDA60D21139F96F2E2F2DDD
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 545 total 6860657 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-13 at 08:58 +0000, Nix wrote:
> I upgraded from 2.6.23.10 to 2.6.24.2 yesterday, and found NFS service
> failing.
> 
> To be specific, all locks were blocking forever, with an endless flood
> of
> 
> Feb 12 22:53:10 loki notice: kernel: statd: server localhost not responding, timed out
> Feb 12 22:53:10 loki notice: kernel: lockd: cannot monitor esperi
> Feb 12 22:53:45 loki notice: kernel: statd: server localhost not responding, timed out
> Feb 12 22:53:45 loki notice: kernel: lockd: cannot monitor esperi
> Feb 12 22:54:20 loki notice: kernel: statd: server localhost not responding, timed out
> Feb 12 22:54:20 loki notice: kernel: lockd: cannot monitor esperi
> Feb 12 22:54:55 loki notice: kernel: statd: server localhost not responding, timed out
> Feb 12 22:54:55 loki notice: kernel: lockd: cannot monitor esperi
> Feb 12 22:55:20 esperi notice: kernel: lockd: server loki.wkstn.nix not responding, still trying
> 
> (esperi is a UML instance on the same machine, connected via a bridged
> TUN/TAP interface: the bridge, and network service to esperi and to the
> rest of the local net across that bridge, was fine.)
> 
> I'm currently using NFSv3 atop nfs-utils 1.1.0.33-gdd08789, with daemons
> being started in the suggested order (portmap, mountd, statd
> --no-notify, nfsd). This evening I'm going to try to upgrade to
> nfs-utils HEAD and see if this continues.

Nothing has changed w.r.t. the statd interface. My 2.6.24 nfsv3 machines
are working without a hitch.
Do 'rpcinfo' and 'netstat -p' show that rpc.statd is listening on a
privileged port?

Cheers
  Trond

