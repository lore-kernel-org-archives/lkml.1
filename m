Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbZDPOcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbZDPOcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 10:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZDPOcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 10:32:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbZDPOcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 10:32:10 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: npiggin@suse.de
Subject: [RFC] Solve problem with page_mkwrite() when blocksize < pagesize
Date: Thu, 16 Apr 2009 16:32:05 +0200
Message-Id: <1239892327-9636-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi,

  patches below are an attempt to solve problems filesystems have with
page_mkwrite() when blocksize < pagesize (see the changelog of the first patch
for details). I'm planning to make also ext3 and ext4 use the new calls but
first I'd like to hear other opinions on this... So what do people here think?

							Thanks
								Honza
