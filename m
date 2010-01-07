Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349Ab0AGQxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab0AGQxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 11:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382Ab0AGQxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 11:53:48 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:63461 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab0AGQxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 11:53:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HBHxJrkK9VZoFd/Bdce3lMH80ngSUkmEAUuDwFka0BCJgU2KVoObLBXTOfPiB1Wzum
         tWMYMLbiE6bQed5sPxr61+JECzPxqoxwmWe43D2GHDeYzfz1mlOeCqotNn3SErlBGO6X
         lVpyfCHrkEpb5r0MIGCWsRWSAO3/r4KXf/4E4=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] x86: Merge atomic headers
Date: Thu,  7 Jan 2010 11:53:32 -0500
Message-Id: <1262883215-4034-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset merges the implementations of the atomic_t functions which 
are common between 32-bit and 64-bit mode.  It splits out the atomic64_t
functions into new headers since those are still different.

[PATCH 1/3] x86: Split atomic64_t functions into seperate headers
[PATCH 2/3] x86: Sync atomic_xx.h
[PATCH 3/3] x86: Merge atomic.h

 arch/x86/include/asm/atomic.h      |  299 ++++++++++++++++++++++-
 arch/x86/include/asm/atomic64_32.h |  160 ++++++++++++
 arch/x86/include/asm/atomic64_64.h |  224 +++++++++++++++++
 arch/x86/include/asm/atomic_32.h   |  415 ------------------------------
 arch/x86/include/asm/atomic_64.h   |  485 ------------------------------------
 5 files changed, 681 insertions(+), 902 deletions(-)

