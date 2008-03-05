Return-Path: <linux-kernel-owner+w=401wt.eu-S1763651AbYCEIBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763651AbYCEIBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 03:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763980AbYCEIAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 03:00:18 -0500
Received: from smtp-out.google.com ([216.239.33.17]:20300 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763645AbYCEIAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 03:00:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:user-agent:date:from:to:cc:subject;
	b=s3xqV1+F+wQcGhDeS3d+5q4H+xXu13jXK5eI6zeyAlJbX9SnU9Wo/Rv3J6/Rn34Px
	6/McMpFNfrlwvpI3jyNnA==
Message-Id: <20080305075237.608599000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Tue, 04 Mar 2008 23:52:37 -0800
From: menage@google.com
To: pj@sgi.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/2] Cpuset hardwall flag:  Introduction
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the cpusets mem_exclusive flag is overloaded to mean both
"no-overlapping" and "no GFP_KERNEL allocations outside this cpuset".

These patches add a new mem_hardwall flag with just the allocation
restriction part of the mem_exclusive semantics, without breaking
backwards-compatibility for those who continue to use just
mem_exclusive. Additionally, the cgroup control file registration for
cpusets is cleaned up to reduce boilerplate.

Signed-off-by: Paul Menage <menage@google.com>

--
