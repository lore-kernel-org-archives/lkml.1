Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890AbZG1LBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbZG1LBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 07:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbZG1LBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 07:01:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:54126 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbZG1LBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 07:01:43 -0400
From: Ludwig Nussel <ludwig.nussel@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] implement uid mount option for ext2 and ext3, try 3
Date: Tue, 28 Jul 2009 13:01:41 +0200
Message-Id: <1248778903-3596-1-git-send-email-ludwig.nussel@suse.de>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1248348991-849-1-git-send-email-ludwig.nussel@suse.de>
References: <1248348991-849-1-git-send-email-ludwig.nussel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by  Andreas Dilger, map _all_ files to the specified
uid and also store the specified uid on disk instead of using root.
Optionally the uid used on disk can be specified.

Additionally the gid can be changed too now in the same way as the
uid.

