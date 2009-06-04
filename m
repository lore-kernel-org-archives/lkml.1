Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbZFDSWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbZFDSWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZFDSWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:22:18 -0400
Received: from senator.holtmann.net ([87.106.208.187]:48661 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbZFDSWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:22:18 -0400
Subject: Re: [GIT PULL] drm-intel fixes for 2.6.30-rc8
From: Marcel Holtmann <marcel@holtmann.org>
To: Eric Anholt <eric@anholt.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1244133916.11142.14.camel@gaiman.anholt.net>
References: <1244133916.11142.14.camel@gaiman.anholt.net>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 20:21:53 +0200
Message-Id: <1244139713.23850.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

> The following changes since commit 9fa7eb283c5cdc2b0f4a8cfe6387ed82e5e9a3d3:
>   Linus Torvalds (1):
>         Linux 2.6.30-rc8
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel for-linus
> 
> This fixes a bogus BUG_ON that I saw get triggered with the new texture
> tiling code on gen4.  There are a couple of lovely further bugfixes in
> drm-intel-next, but it's rc8 and I'd rather help quiet things down
> so .30 gets out the door :)

no idea if this has any relation to it. I am running wireless-testing
which is based on 2.6.30-rc8 and I got this (for the the first time):

[   46.185008] [drm:gm45_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 0
[   54.606049] metacity[2319]: segfault at 0 ip 0000000000462a4e sp 00007fff412e4f60 error 4 in metacity[400000+86000]

Regards

Marcel


