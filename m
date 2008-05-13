Return-Path: <linux-kernel-owner+w=401wt.eu-S1759675AbYEMQTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759675AbYEMQTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 12:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757670AbYEMQTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 12:19:34 -0400
Received: from outbound-mail-140.bluehost.com ([67.222.39.30]:54103 "HELO
	outbound-mail-140.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757413AbYEMQTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 12:19:33 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: [PATCH] drm/radeon: radeon_enable_vblank should return negative error
Date: Tue, 13 May 2008 09:19:28 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@redhat.com>,
       Andrew Morton <akpm@osdl.org>
References: <20080511194906.GA19058@joi>
In-Reply-To: <20080511194906.GA19058@joi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805130919.28539.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 11, 2008 12:49 pm Marcin Slusarz wrote:
> radeon_enable_vblank <- drm_vblank_get <- drm_wait_vblank
> and drm_wait_vblank returns negative values on error
>
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
> compile tested only

Looks good, Marcin.  Andrew should probably just push it upstream.

Acked-by:  Jesse Barnes <jbarnes@virtuousgeek.org>

Thanks,
Jesse
