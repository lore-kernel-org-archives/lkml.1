Return-Path: <linux-kernel-owner+w=401wt.eu-S935270AbXGYSdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935270AbXGYSdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934864AbXGYSc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:32:58 -0400
Received: from outbound-mail-49.bluehost.com ([69.89.18.18]:52215 "HELO
	outbound-mail-49.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933727AbXGYSc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:32:56 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: [drm:i810_wait_ring] *ERROR* space: 65476 wanted 65528
Date: Wed, 25 Jul 2007 11:32:55 -0700
User-Agent: KMail/1.9.4
Cc: linux-kernel@vger.kernel.org
References: <BAY103-DAV11C722665A129F5F6A5EFDB2F00@phx.gbl>
In-Reply-To: <BAY103-DAV11C722665A129F5F6A5EFDB2F00@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707251132.55765.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 198.145.33.2 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 24, 2007 2:55 am, Marco Berizzi wrote:
> Hello everybody.
> I'm running Slackware 12 with 2.6.23-rc1
> and when I start X i get this error:
>
> Jul 24 10:11:16 Calimero kernel: [drm:drm_release] *ERROR*
> reclaim_buffers_locked() deadlock. Please rework this
> Jul 24 10:11:16 Calimero kernel: driver to use
> reclaim_buffers_idlelocked() instead.
> Jul 24 10:11:16 Calimero kernel: will go on reclaiming the buffers
> anyway.
> Jul 24 10:11:26 Calimero kernel: [drm:i810_wait_ring] *ERROR* space:
> 65476 wanted 65528
> Jul 24 10:11:26 Calimero kernel: [drm:i810_wait_ring] *ERROR* lockup
> Jul 24 10:11:31 Calimero kernel: [drm:i810_wait_ring] *ERROR* space:
> 65468 wanted 65528
> Jul 24 10:11:31 Calimero kernel: [drm:i810_wait_ring] *ERROR* lockup

Looks like a DRM driver problem.  Can you file a bug for this at 
freedesktop.org if there's not one already?

Thanks,
Jesse
