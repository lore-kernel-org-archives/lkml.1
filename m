Return-Path: <linux-kernel-owner+w=401wt.eu-S1755727AbYLME4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbYLME4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 23:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbYLMEzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 23:55:55 -0500
Received: from xenotime.net ([72.52.64.118]:47589 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754009AbYLMEzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 23:55:54 -0500
Message-ID: <4943405A.4080009@xenotime.net>
Date: Fri, 12 Dec 2008 20:55:54 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jesse.barnes@intel.com, airlied@linux.ie
Subject: Re: linux-next: Tree for December 12 (drm)
References: <20081212185654.0af8b4a1.sfr@canb.auug.org.au>
In-Reply-To: <20081212185654.0af8b4a1.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20081211:
> 
> Undropped tree:
> 	drm

oops    ^^^


When I2C=n, and drm is built-in or modular, this build error
happens:

(drm built-in:)

build-r7079.out:(.text+0x47e5f): undefined reference to `i2c_transfer'
7080	same
7086	same
7089	same
(from gpu/drm/drm_edid.c)


(drm modular:)

build-r7103.out:ERROR: "i2c_transfer" [drivers/gpu/drm/drm.ko] undefined!
(from gpu/drm/drm_edid.c)


~Randy


