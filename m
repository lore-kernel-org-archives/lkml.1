Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753535AbYLRLn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbYLRLn2 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 06:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbYLRLmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 06:42:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40974 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbYLRLm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 06:42:28 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-api@vger.kernel.org
Cc: aarcange@redhat.com, Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v4 0/3] System call design: preadv & pwritev.
Date: Thu, 18 Dec 2008 12:42:19 +0100
Message-Id: <1229600542-11585-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi folks,

Guess I have your attention now thanks to LWN ;)

Next round of the preadv & pwritev patch series, hopefully finally
solving the architecture issues.  I've decided to go with the suggestion
from the s390 guys:  split the 64bit offset into two explicitly coded
32bit halves.  The syscall prototype should work now for all archs
without (in-kernel) wrappers.  glibc must wrap the syscalls though to
hide that split from the applications.  But there is no way around glibc
wrappers anyway, so I think that is sensible decision.

cheers,
  Gerd

