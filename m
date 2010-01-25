Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044Ab0AYVRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab0AYVRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626Ab0AYVRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:17:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52074 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab0AYVRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:17:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] PM / i915: Skip kernel VT switch during suspend/resume if KMS is used
Date: Mon, 25 Jan 2010 22:17:39 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net, Eric Anholt <eric@anholt.net>,
       airlied@linux.ie
References: <201001240055.59479.rjw@sisk.pl> <20100125184350.0fbad233@lxorguk.ukuu.org.uk> <20100125104938.6b34d61c@jbarnes-piketon>
In-Reply-To: <20100125104938.6b34d61c@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001252217.39778.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 January 2010, Jesse Barnes wrote:
> On Mon, 25 Jan 2010 18:43:50 +0000
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > This probably belongs in the core DRM KMS code instead of the
> > > driver. I can imagine that there may be some X driver code that
> > > still needs to be executed on suspend/resume for some drivers, so
> > > this may introduce bugs, but it's definitely the right way to go.
> > 
> > You can have a mix of KMS and non KMS consoles active on different
> > cards. So I don't think that is the case.
> 
> I pity users with that configuration.
> 
> But in that case we should be able to disable the VT switch disable
> path; we just have to check each driver as it's loaded.

OK, what the right sequence of checks would be in that case and where to place
them?

Rafael
