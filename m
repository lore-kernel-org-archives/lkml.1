Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbYBJMs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbYBJMs5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 07:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbYBJMsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 07:48:47 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:23069 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbYBJMsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 07:48:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject;
        b=yGgXhC8UIUyEZqAVmhZlMITkHXe7Wy2lEqlLRfnvhgAXpGJ5DMtcuo+GZJVphRcxxRDImTUcbQ/DSJy0CwAP+uXkYpzpiJmIzzz2xqJxPIKcJSz2RtHVGDqe1HohLmR6Q0a0w3f/psCzcSwFmfv8DkmwZvIrItkwy8cEbdaAd2g=
Message-Id: <20080210124323.068409407@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 10 Feb 2008 15:43:23 +0300
From: gorcunov@gmail.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: gorcunov@gmail.com
Subject: [patch 0/2] ELF cleanup 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches do a simple cleaunp on ELF related code

	o Use EI_NIDENT instead of numeric value in elf64_hdr structure
	o Simplify fill_elf_header code by calling memset

Please review. Any comments are welcome.

-- 
