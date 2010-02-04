Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab0BDJzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:55:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583Ab0BDJzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:55:17 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (fixes)
Date: Thu,  4 Feb 2010 09:46:19 +0000
Message-Id: <1265276781-4648-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are a couple of patches which between them fix a problem where
occasionally it was possible for the GFS2 module to be unloaded
before all the glocks were deallocated, which, needless to say, made
the slab allocator unhappy,

Steve.

