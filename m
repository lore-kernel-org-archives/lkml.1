Return-Path: <linux-kernel-owner+w=401wt.eu-S1752159AbXDIAF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbXDIAF7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 20:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbXDIAF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 20:05:59 -0400
Received: from iona.labri.fr ([147.210.8.143]:40585 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbXDIAF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 20:05:58 -0400
Date: Mon, 9 Apr 2007 02:05:56 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Add a norecovery option to ext3/4?
Message-ID: <20070409000556.GA13980@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Distribution installers usually try to probe OSes for building a suited
grub menu.  Unfortunately, mounting an ext3 partition, even in read-only
mode, does perform some operations on the filesystem (log recovery).
This is not a good idea since it may silently garbage data.  XFS has a
norecovery option that allows to disable that, I'd say ext3/4 should
have it too.

Samuel
