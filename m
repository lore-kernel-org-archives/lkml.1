Return-Path: <linux-kernel-owner+w=401wt.eu-S934105AbYBUU4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934105AbYBUU4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765320AbYBUU4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:56:00 -0500
Received: from smtp-out.google.com ([216.239.33.17]:24136 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764366AbYBUUz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:55:59 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:user-agent:date:from:to:cc:subject;
	b=lhFyWGTJBl5v0uMBpR0DKM0HnB1SDVGVshGyomSy/b8k8kbE1CKRtnE4kM17wKNVx
	Qds9gd+CYU/viUlBAauSg==
Message-Id: <20080221203518.544461000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Thu, 21 Feb 2008 12:35:18 -0800
From: menage@google.com
To: akpm@linux-foundation.org, xemul@openvz.org, balbir@in.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/2] ResCounter: Add res_counter_read_uint and use it in memory cgroup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches simplify the code required to report values from a
res_counter object in a cgroups control file.

The first patch adds res_counter_read_uint, which simply reports the
current value for a res_counter member.

The second replaces the existing mem_cgroup_read() with a simpler
version that calls res_counter_read_uint().

Signed-off-by: Paul Menage <menage@google.com>

--
