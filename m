Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbYIJL3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbYIJL3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYIJL3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:29:43 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:59036 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbYIJL3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:29:42 -0400
Date: Wed, 10 Sep 2008 12:28:29 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Alex Nixon <alex.nixon@citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] mm: define USE_SPLIT_PTLOCKS rather than repeating
 expression
In-Reply-To: <48C6FC0A.7070102@goop.org>
Message-ID: <Pine.LNX.4.64.0809101227320.18517@blonde.site>
References: <> <1220959508-13806-1-git-send-email-alex.nixon@citrix.com>
 <48C6BB00.9040607@goop.org> <48C6CCD7.8030800@citrix.com> <48C6DE6E.1070804@goop.org>
 <48C6F80E.8010509@citrix.com> <48C6FC0A.7070102@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008, Jeremy Fitzhardinge wrote:
> Define USE_SPLIT_PTLOCKS as a constant expression rather than repeating
> "NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS" all over the place.

Yes, that's much more readable, thanks Jeremy.

> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Acked-by: Hugh Dickins <hugh@veritas.com>
