Return-Path: <linux-kernel-owner+w=401wt.eu-S1765591AbYCEK0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765591AbYCEK0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 05:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764393AbYCEKZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 05:25:37 -0500
Received: from smtp-out.google.com ([216.239.33.17]:35097 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763989AbYCEKZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 05:25:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:user-agent:date:from:to:cc:subject;
	b=mrnSO6yD3x1fIE1R4jFst0pY4SARlPWo5M6QjuGlFe/oD4Hq4BEJqre6AdCVXMeG4
	BATGelngutR72ZZbBut7g==
Message-Id: <20080305102025.677459000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Wed, 05 Mar 2008 02:20:25 -0800
From: menage@google.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH 0/2] CGroups _s64 files: Intro
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add cgroups read_s64 and write_s64 control file methods
(the signed equivalent of read_u64/write_u64) and use them to
implement the cpu.rt_runtime_us control file in the CFS cgroup
subsystem.

Signed-off-by: Paul Menage <menage@google.com>

--
