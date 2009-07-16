Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbZGPMbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbZGPMbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 08:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282AbZGPMbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 08:31:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43742 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbZGPMbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 08:31:11 -0400
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/20] ceph: on-wire types
From: Andi Kleen <andi@firstfloor.org>
References: <1247693090-27796-1-git-send-email-sage@newdream.net>
	<1247693090-27796-2-git-send-email-sage@newdream.net>
	<1247693090-27796-3-git-send-email-sage@newdream.net>
Date: Thu, 16 Jul 2009 14:31:10 +0200
In-Reply-To: <1247693090-27796-3-git-send-email-sage@newdream.net> (Sage Weil's message of "Wed, 15 Jul 2009 14:24:32 -0700")
Message-ID: <878wiox10x.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sage Weil <sage@newdream.net> writes:
> +
> +/*
> + * Max file size is a policy choice; in reality we are limited
> + * by 2^64.
> + */
> +#define CEPH_FILE_MAX_SIZE (1ULL << 40)   /* 1 TB */

Seems odd to hardcode this here.

The way attribute packed is used in these files seems rather
random and adhoc, sometimes it is, sometimes it isn't.

I assume you tested that 32bit and 64bit interoperability?

Is the file system supposed to be endian safe on the wire?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
