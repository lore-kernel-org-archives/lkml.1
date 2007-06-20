Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbXFTWtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbXFTWtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbXFTWsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:48:50 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:54696 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752875AbXFTWst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:48:49 -0400
Date: Thu, 21 Jun 2007 00:48:47 +0200
From: Carlo Wood <carlo@alinoe.com>
To: linux-kernel@vger.kernel.org
Subject: SATA Harddisk speed drop of 100 MB/s
Message-ID: <20070620224847.GA5488@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hdparm -tT gives over 160 MB/s for my tripple 10k rpm Raptor RAID5
on 2.6.18, as expected.

In 2.6.22-rc5 this dropped to only 60 MB/s !

Is this a known issue?

I also measured it with bonnie; I get 108 MB/s reading speed on
2.6.18 and only 68 MB/s on 2.6.22-rc5.

-- 
Carlo Wood <carlo@alinoe.com>
