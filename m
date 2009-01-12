Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbZALG4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbZALG4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 01:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbZALG4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 01:56:38 -0500
Received: from mga03.intel.com ([143.182.124.21]:14582 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbZALG4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 01:56:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,251,1231142400"; 
   d="scan'208";a="98888388"
Subject: [PATCH 0/3]use new async API for shutdown
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 14:56:36 +0800
Message-Id: <1231743396.5867.46.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
these are my attempt to make .shutdown executed asynchronous. Some
drivers's shutdown take a lot of time. The patches can help save some
shutdown time. The patches are using Arjan's async API.

Thanks,
Shaohua

