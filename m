Return-Path: <linux-kernel-owner+w=401wt.eu-S1752211AbZL3WBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbZL3WBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 17:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbZL3WBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 17:01:08 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53182 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbZL3WBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 17:01:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes when ..."
Date: Wed, 30 Dec 2009 23:00:55 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: keithp@keithp.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
       linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
       dri-devel@lists.sourceforge.net
References: <200912071830.14697.arnd@arndb.de> <200912211757.08305.arnd@arndb.de> <20091228104741.7e5aa82a@jbarnes-x200>
In-Reply-To: <20091228104741.7e5aa82a@jbarnes-x200>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912302300.55307.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+fTX/BATawEz2wAvqHZ+3UY/tPRFlG/ANKNF6
 eXyXtnsM6X2eE3/QWrh6w0xiI/Yz6qMvPV7kq6yfK0HBUMTF9Y
 HOdo1E+6ed2GuQYEQKHiw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 December 2009, Jesse Barnes wrote:
> This code should be completely gone in Eric's drm-intel-next branch
> (from
> git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel.git), so
> hopefully when that lands upstream (if it hasn't already) things will
> be solid for you.

Unfortunately, it seems it did not help. I could also reproduce the hang
with your patch that I reported working for two days before Christmas,
and with the version of that patch that I posted later. I'm running
04302965 again now, and try to apply other parts of the patch that
introduced the regression.

	Arnd
