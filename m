Return-Path: <linux-kernel-owner+w=401wt.eu-S1760616AbXGYFEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760616AbXGYFEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 01:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbXGYFEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 01:04:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57709 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750946AbXGYFEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 01:04:46 -0400
Date: Tue, 24 Jul 2007 22:03:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, wwoods@redhat.com
Subject: Re: [PATCH]: allow individual core dump methods to be unlimited
 when sending to a pipe
Message-Id: <20070724220358.864db265.akpm@linux-foundation.org>
In-Reply-To: <20070724151738.GB23976@hmsreliant.homelinux.net>
References: <20070722153947.GA11941@hmsreliant.homelinux.net>
	<20070724020939.7644f18c.akpm@linux-foundation.org>
	<20070724151738.GB23976@hmsreliant.homelinux.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


SuperH allmodconfig broke:

fs/binfmt_flat.c:83: warning: initialization from incompatible pointer type
fs/binfmt_flat.c:94: error: conflicting types for 'flat_core_dump'
fs/binfmt_flat.c:78: error: previous declaration of 'flat_core_dump' was here
fs/binfmt_flat.c:94: error: conflicting types for 'flat_core_dump'
fs/binfmt_flat.c:78: error: previous declaration of 'flat_core_dump' was here
fs/binfmt_flat.c: In function `decompress_exec':
fs/binfmt_flat.c:293: warning: label `out' defined but not used
fs/binfmt_flat.c: In function `load_flat_file':
fs/binfmt_flat.c:462: warning: unsigned int format, long int arg (arg 3)
fs/binfmt_flat.c:462: warning: unsigned int format, long int arg (arg 4)
fs/binfmt_flat.c:518: warning: comparison of distinct pointer types lacks a cast
fs/binfmt_flat.c:549: warning: passing arg 1 of `ksize' makes pointer from integer without a cast
fs/binfmt_flat.c:601: warning: passing arg 1 of `ksize' makes pointer from integer without a cast
fs/binfmt_flat.c: At top level:
fs/binfmt_flat.c:78: warning: 'flat_core_dump' used but never defined
fs/binfmt_flat.c:94: warning: 'flat_core_dump' defined but not used
