Return-Path: <linux-kernel-owner+w=401wt.eu-S1753013AbXLFKS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbXLFKS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 05:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbXLFKSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 05:18:48 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56464 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbXLFKSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 05:18:48 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Denis V. Lunev" <den@openvz.org>
Cc: akpm@linux-foundation.org, marcus@better.se, containers@lists.osdl.org,
       devel@openvz.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lost content of /proc/sys/fs/binfmt_misc
References: <20071205143518.GA24886@iris.sw.ru>
Date: Thu, 06 Dec 2007 03:17:16 -0700
In-Reply-To: <20071205143518.GA24886@iris.sw.ru> (Denis V. Lunev's message of
	"Wed, 5 Dec 2007 17:35:18 +0300")
Message-ID: <m1fxygt9eb.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Denis V. Lunev" <den@openvz.org> writes:

> /proc/sys/fs/binfmt_misc dentry disappeared during d_revalidate.
> d_revalidate only dentries from shadowed one and below.
> http://bugzilla.kernel.org/show_bug.cgi?id=9504

Denis this is decent except it doesn't completely close the possibility of
leaking mounts.  It just refuses to leak mounts on everything except /proc/net.

Eric
