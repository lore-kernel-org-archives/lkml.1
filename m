Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbYE1V42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbYE1V42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbYE1V4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:56:15 -0400
Received: from styx.suse.cz ([82.119.242.94]:54449 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752587AbYE1V4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:56:15 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
       Jan Kara <jack@suse.cz>
Subject: [PATCH] Silence warnings about non-uptodate buffers
Date: Wed, 28 May 2008 23:56:08 +0200
Message-Id: <12120117733479-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

the series of patches below gets rid of warning messages in mark_buffer_dirty()
when underlying block device becomes unavailable. Andrew, would you merge them
please?

								Honza
