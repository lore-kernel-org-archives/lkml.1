Return-Path: <linux-kernel-owner+w=401wt.eu-S1759375AbZDWSdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375AbZDWSdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 14:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757303AbZDWSdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 14:33:41 -0400
Received: from verein.lst.de ([213.95.11.210]:38182 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757991AbZDWSdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 14:33:40 -0400
Date: Thu, 23 Apr 2009 20:33:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: linux-arch@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
Cc: linux-kernel@vger.kernel.org
Subject: USE_ELF_CORE_DUMP?
Message-ID: <20090423183331.GA19899@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently all architectures but microblaze unconditionally define
USE_ELF_CORE_DUMP.  The microblaze ommision seems like an error to
me, so can we just kill this ifdef and make sure we are the same
everywhere?
