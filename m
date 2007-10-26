Return-Path: <linux-kernel-owner+w=401wt.eu-S1765208AbXJZXj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765208AbXJZXj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 19:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763442AbXJZXiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 19:38:50 -0400
Received: from smtp-out.google.com ([216.239.45.13]:12197 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762962AbXJZXit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 19:38:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:cc:subject;
	b=cvhy2JFCMIh8Wr7zDg5W89z6r12vpGUSyquZe8hrNW5hlGEnxhJfN7Sr1Fs/40vtU
	OByvtN70P1a7uRdFjldNg==
Message-Id: <20071026233732.568575496@crlf.corp.google.com>
Date: Fri, 26 Oct 2007 16:37:32 -0700
From: Mike Waychison <mikew@google.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/6][RFC] Cleanup FIBMAP
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following series is meant to clean up FIBMAP paths with the eventual goal of allowing users to be able to FIBMAP their data.

I'm sending this as an RFC as I've only tested this on a x86_64 kernel with a 32bit binary on ext2 and I've noticed a couple ext2_warnings already.

I'm unsure of the locking in [4/6] fix_race_with_truncate.patch.  Any help here would greatly be appreciated.

The last patch, [6/6] drop_cap_sys_rawio_for_fibmap.patch, is of course, not to be applied until any remaining issues are fixed :)

Thanks,

Mike Waychison
--
