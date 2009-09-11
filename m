Return-Path: <linux-kernel-owner+w=401wt.eu-S1752502AbZIKCcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbZIKCcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 22:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZIKCcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 22:32:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:2578 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbZIKCcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 22:32:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,367,1249282800"; 
   d="scan'208";a="186432877"
Message-Id: <20090911022333.324128054@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 11 Sep 2009 10:23:33 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Johannes Berg <johannes@sipsolutions.net>
CC: Avi Kivity <avi@qumranet.com>
cc: Andi Kleen <andi@firstfloor.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] /dev/mem cleanups and bug fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here are three patches for /dev/[k]mem.
They are mostly code cleanups, plus a minor bug fix:
if someone read high mem via /dev/kmem starting from
an unaligned address, it's calculation of 'len' will
go wrong.

I would recommend them for .32.

Thanks,
Fengguang
-- 

