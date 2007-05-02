Return-Path: <linux-kernel-owner+w=401wt.eu-S2993213AbXEBOE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993213AbXEBOE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 10:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993215AbXEBOE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 10:04:58 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:55590 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993213AbXEBOE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 10:04:57 -0400
Date: Wed, 2 May 2007 15:04:44 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Phillip Susi <psusi@cfl.rr.com>
cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Execute in place
In-Reply-To: <4637B751.1080907@cfl.rr.com>
Message-ID: <Pine.LNX.4.64.0705021502450.16517@blonde.wat.veritas.com>
References: <4637B751.1080907@cfl.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 02 May 2007 14:04:56.0948 (UTC) FILETIME=[DD681B40:01C78CC2]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAAmluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAcHN1c2lAY2ZsLnJyLmNvbQA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, Phillip Susi wrote:
> I seem to remember seeing some patches go by at some point that allowed one of
> the rom type embeded system filesystems to directly execute binaries out of
> the original rom memory rather than copying them to ram first, then executing
> from there.  I was wondering if rootfs or tmpfs support such execute in place
> today, or if binaries executed from there have their code segments duplicated
> in ram?

Only ext2 supports it today: see Documentation/filesystems/xip.txt

Hugh
