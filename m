Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbXDOXMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbXDOXMG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 19:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbXDOXMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 19:12:06 -0400
Received: from cobalt0.barnhard.net ([216.181.81.129]:55518 "EHLO
	cobalt0.barnhard.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbXDOXMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 19:12:05 -0400
Date: Mon, 16 Apr 2007 00:11:51 +0100
From: Dale Amon <amon@vnl.com>
To: Dale Amon <amon@vnl.com>, linux-kernel@vger.kernel.org
Subject: Re: Problem with ufs nextstep in 2.6.18 (debian)
Message-ID: <20070415231151.GC5129@vnl.com>
Mail-Followup-To: Dale Amon <amon@vnl.com>, linux-kernel@vger.kernel.org
References: <20070415013848.GG4770@vnl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415013848.GG4770@vnl.com>
X-Operating-System: Linux, the choice of a GNU generation
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The error also happens in 2.6.19, same as in 2.6.18. I
extracted this from syslog:

Apr 17 00:14:08 kdev kernel: loop: loaded (max 8 devices)
Apr 17 00:14:15 kdev kernel: UFS-fs error (device loop0): ufs_check_page: bad entry in directory #2: directory entry across blocks - offset=356, rec_len=668, name_len=19
Apr 17 00:14:15 kdev kernel: UFS-fs error (device loop0): ufs_readdir: bad page in #2

