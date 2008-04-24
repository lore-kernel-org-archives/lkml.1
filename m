Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbYDXLvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbYDXLvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 07:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYDXLvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 07:51:24 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:57083 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751666AbYDXLvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 07:51:23 -0400
Message-ID: <4810752F.30205@valinux.co.jp>
Date: Thu, 24 Apr 2008 20:55:27 +0900
From: KAIZUKA Hiroyuki <kaizuka@valinux.co.jp>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
       xen-devel@lists.xensource.com
Cc: agk@sourceware.org
Subject: Utility tool for dm-ioband.
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I made a utility tool for dm-ioband version 0.0.4, named iobandctl.

It enables you to easily apply I/O bandwidth control to an entire disk,
and manage it. It helps you set the percentage of bandwidth
to give each partition, and each user, process, group, or cgroup.
(You are not able to use cgroup support yet, because the dm-ioband
patch to enable cgroup support (http://lwn.net/Articles/273802/)
is not ported to linux-2.6.25, but it will be soon.)

You can download it and find the manual at
http://people.valinux.co.jp/~kaizuka/dm-ioband/iobandctl/

This is a prototype code.
So, I'd like to hear your requests.
Feature fixed, it is going to be re-written in C.

Thanks,
KAIZUKA Hiroyuki
