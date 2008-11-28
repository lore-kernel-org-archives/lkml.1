Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbYK1FUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbYK1FUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 00:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYK1FT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 00:19:57 -0500
Received: from outbound-mail-124.bluehost.com ([67.222.38.24]:45749 "HELO
	outbound-mail-124.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750730AbYK1FT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 00:19:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=s1nKkQTAabAXK9bslMieP4mkNu93Ri7CcvAy0QRXx1uyVgcZnK4G4BpDxg3CKS7SAl4E4MVEtbO3RUgWHZKRORUaXHJx38s29kFiPgm1tghCsMjrV77PwmQvIDixMfao;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: dri-devel@lists.sourceforge.net
Subject: Re: [git pull] drm fixes for 2.6.28 final
Date: Thu, 27 Nov 2008 21:19:54 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
References: <alpine.DEB.2.00.0811280325110.25353@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.2.00.0811280325110.25353@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811272119.54619.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 27, 2008 7:26 pm Dave Airlie wrote:
> Hi Linus,
>
> Please pull the 'drm-fixes' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
> drm-fixes
>
> This larger than we wished patch, fixes a number of regressions reported.
>
> 1. vblank rework causes hangs on VT switch - fixes touches all drivers.

To clarify here, only one userspace driver was actually silly enough to 
disable IRQs at VT leave time, xf86-video-intel.  But the DRM fix applies to 
all drivers just to be on the safe side.  It's a bit invasive, but ultimately 
a bit safer than leaving things.


-- 
Jesse Barnes, Intel Open Source Technology Center

