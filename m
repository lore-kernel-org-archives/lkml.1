Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbYAGSrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbYAGSrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 13:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbYAGSre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 13:47:34 -0500
Received: from smtp-out.google.com ([216.239.45.13]:31510 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYAGSre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 13:47:34 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:mime-version:
	content-type:content-transfer-encoding:content-disposition;
	b=V0x7Q4JZVpfMWaiE/pHQA9pOZVecve/pBUruivhKRYq3VbtR4T9q7ULz9YpKAhoVf
	lbFJTJpQpTob/xjLkY9aA==
Message-ID: <532480950801071047xf7fa0b7te3967484a34190a7@mail.gmail.com>
Date: Mon, 7 Jan 2008 10:47:27 -0800
From: "Michael Rubin" <mrubin@google.com>
To: linux-kernel@vger.kernel.org, "WU Fengguang" <wfg@mail.ustc.edu.cn>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Writing tests for write back
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am writing tests for the write back section of the kernel. This is
the stuff found in fs/fs-writeback.c.

Currently I have tests to fsync millions of inodes concurrently, tests
involving mounting and unmounting file systems, and other tests to
tickle some starvation of big file situations. Has anyone else been
bitten by writeback not performing correctly either in the past or
now? If so please send me the situation so I can incorporate it into
my tests and also make sure my new attempt at an implementation does
not cause damage.

These tests will end up in autotest on test.kernel.org so they will
become something the whole community can use.

mrubin
