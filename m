Return-Path: <linux-kernel-owner+w=401wt.eu-S1763588AbYBMKU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763588AbYBMKU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 05:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbYBMKUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 05:20:50 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40685 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197AbYBMKUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 05:20:49 -0500
Date: Wed, 13 Feb 2008 02:19:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: Upgrade to 2.6.24 breaks NFS service
Message-Id: <20080213021912.b127c4a7.akpm@linux-foundation.org>
In-Reply-To: <87lk5pjkro.fsf@hades.wkstn.nix>
References: <87lk5pjkro.fsf@hades.wkstn.nix>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-nfs)

On Wed, 13 Feb 2008 08:58:03 +0000 Nix <nix@esperi.org.uk> wrote:

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
> 

