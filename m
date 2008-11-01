Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbYKAUbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbYKAUbZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 16:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYKAUbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 16:31:18 -0400
Received: from twin.jikos.cz ([213.151.79.26]:60255 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbYKAUbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 16:31:17 -0400
Date: Sat, 1 Nov 2008 21:31:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: f.duncan.m.haldane@att.net
cc: linux-kernel@vger.kernel.org
Subject: Re: [STAGING]: How does one set CONFIG_STAGING=y in 2.6.28-rc2 ?
In-Reply-To: <110120081910.8202.490CA9B3000451E20000200A22228869349B0A02D29B9B0EBF0A020E0B040E08D203D2020E0C029A0BD200@att.net>
Message-ID: <alpine.LRH.1.10.0811012130050.19257@twin.jikos.cz>
References: <110120081910.8202.490CA9B3000451E20000200A22228869349B0A02D29B9B0EBF0A020E0B040E08D203D2020E0C029A0BD200@att.net>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2008, f.duncan.m.haldane@att.net wrote:

> I want to experiment with the "staging" driver go7007 in 2.6.28-rc2 (try 
> to build on ARM/orion_5x)
> There seems no way to configure the build system to see the drivers in 
> drivers/staging. Is this a missing patch to kbuild, or have I missed 
> something?

It should be seen under Device Drivers -> Staging drivers in menuconfig. 
Works for me. CONFIG_STAGING doesn't have any dependency, so you really 
should be able to see it.

-- 
Jiri Kosina
SUSE Labs

