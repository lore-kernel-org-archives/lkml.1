Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbZJNGam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbZJNGam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbZJNGam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:30:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:52050 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871AbZJNGal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:30:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,555,1249282800"; 
   d="scan'208";a="198717070"
Subject: [RFC 0/2] Unified UUID/GUID definition
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
       Steven Whitehouse <swhiteho@redhat.com>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 14 Oct 2009 14:30:03 +0800
Message-Id: <1255501803.6047.1191.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All,

This patchset is an attempt to provide a unified UUID/GUID definition to
replace various UUID/GUID definitions in current kernel. This will make
kernel source more readable and unify some duplicated efforts.

This is a RFC to talk about the general UUID/GUID definition design.
Only 

UUID/GUID is used by many modules/subsystems in kernel. But this
patchset only replace one of them to use the new definition as an
example. After consensus is reached, we can replace other UUID/GUID
usage too.

This patchset is based on Joe's UUID printk support patchset:

[PATCH 0/9] Add vsprintf extension %pU to print UUID/GUIDs and use it

Any comment is welcome.

Best Regards,
Huang Ying


