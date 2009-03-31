Return-Path: <linux-kernel-owner+w=401wt.eu-S1760965AbZCaAD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965AbZCaAD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 20:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760669AbZCaABe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 20:01:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59796 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760601AbZCaABd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 20:01:33 -0400
From: Izik Eidus <ieidus@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, aarcange@redhat.com, chrisw@redhat.com, riel@redhat.com,
       jeremy@goop.org, mtosatti@redhat.com, hugh@veritas.com, corbet@lwn.net,
       yaniv@redhat.com, dmonakhov@openvz.org, Izik Eidus <ieidus@redhat.com>
Subject: [PATCH 0/2] kvm-userspace ksm support
Date: Tue, 31 Mar 2009 03:00:26 +0300
Message-Id: <1238457628-7668-1-git-send-email-ieidus@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apply it against Avi kvm-userspace git tree.

Izik Eidus (2):
  qemu: add ksm support
  qemu: add ksmctl.

 qemu/ksm.h                 |   70 ++++++++++++++++++++++++++++++++++++++++++++
 qemu/vl.c                  |   34 +++++++++++++++++++++
 user/Makefile              |    6 +++-
 user/config-x86-common.mak |    2 +-
 user/ksmctl.c              |   69 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 179 insertions(+), 2 deletions(-)
 create mode 100644 qemu/ksm.h
 create mode 100644 user/ksmctl.c

