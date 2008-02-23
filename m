Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYBWX2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYBWX2y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 18:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757212AbYBWX1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 18:27:48 -0500
Received: from smtp-out.google.com ([216.239.33.17]:5173 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158AbYBWX1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 18:27:47 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:user-agent:date:from:to:cc:subject;
	b=j5dDf+AFPL4TrLlq94cFp4YJ026Ve5O+wt7fDledL9VOMcM0tMu5FWUUocE8+4v4g
	c4sqp3M7KdmY0GaazsJvw==
Message-Id: <20080223224725.115590000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Sat, 23 Feb 2008 14:47:25 -0800
From: menage@google.com
To: akpm@linux-foundation.org, balbir@in.ibm.com, pj@sgi.com,
       Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH 00/10] CGroup API files: Various cleanup to CGroup control files
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is a roll-up of the non-contraversial items of the
various patches that I've sent out recently, fixed according to the
feedback received.

In summary they are:

- general rename of read_uint/write_uint to read_u64/write_u64

- use these methods for cpusets and memory controller files

- add a read_map cgroup file method, and use it in the memory
  controller

- move the "releasable" control file to the debug subsystem

- make the debug subsystem config option default to "n"

The only user-visible changes are the movement of the "releasable"
file and the fact that some write_u64()-based control files are now
more forgiving of additional whitespace at the end of their input.

Signed-off-by: Paul Menage <menage@google.com>

--
