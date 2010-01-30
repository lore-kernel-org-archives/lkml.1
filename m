Return-Path: <linux-kernel-owner+w=401wt.eu-S1752196Ab0A3HNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab0A3HNG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 02:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024Ab0A3HNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 02:13:05 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:39042 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab0A3HNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 02:13:04 -0500
Authentication-Results: sj-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMtqY0urR7Ht/2dsb2JhbADBVpdAhEIE
X-IronPort-AV: E=Sophos;i="4.49,373,1262563200"; 
   d="scan'208";a="236570694"
From: Roland Dreier <rdreier@cisco.com>
To: Alex Chiang <achiang@hp.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Increase maximum Infiniband HCAs per-system
References: <20100129214039.17745.38679.stgit@bob.kio>
	<adar5p8ldxv.fsf@roland-alpha.cisco.com>
	<20100129234145.GC5177@ldl.fc.hp.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 29 Jan 2010 23:13:00 -0800
In-Reply-To: <20100129234145.GC5177@ldl.fc.hp.com> (Alex Chiang's message of
	"Fri, 29 Jan 2010 16:41:45 -0700")
Message-ID: <adamxzwkqv7.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > What I'm a little unsure of is, does IB_UMAD_MAX_AGENTS need to
 > double too? We don't export the agent id in the filesystem
 > anywhere, but we do give it to the user via an ioctl. That's just
 > used for book keeping purposes but...

I don't think so.  That is a limit on "agents" registered per open file,
so it is orthogonal to the number of devices.

 - R.
