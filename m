Return-Path: <linux-kernel-owner+w=401wt.eu-S1763480AbXJEPno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763480AbXJEPno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 11:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761332AbXJEPnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 11:43:31 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:62077 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760395AbXJEPna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 11:43:30 -0400
Date: Fri, 5 Oct 2007 16:43:17 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Guennadi Liakhovetski <lg@denx.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: tmpfs disabled in .config but in /proc/filesystems
In-Reply-To: <Pine.LNX.4.60.0710051637200.10392@poirot.grange>
Message-ID: <Pine.LNX.4.64.0710051637380.16909@blonde.wat.veritas.com>
References: <Pine.LNX.4.60.0710051637200.10392@poirot.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2007, Guennadi Liakhovetski wrote:
> Am I running crazy here (some 2.6.23-rc6-ish)?
> 
> $ zcat /proc/config.gz | grep TMPFS
> # CONFIG_TMPFS is not set
> $ grep tmpfs /proc/filesystems
> nodev   tmpfs

tmpfs (mm/shmem.c) is used by the kernel to support shared memory
of various kinds even when CONFIG_TMPFS is not set.  But only when
CONFIG_TMPFS=y can users mount a tmpfs as a fully capable filesystem.
Confusing, yes: sorry for putting the fear of craziness upon you.

Hugh
