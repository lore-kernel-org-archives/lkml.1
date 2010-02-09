Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab0BIP4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 10:56:19 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:29065 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab0BIP4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 10:56:17 -0500
X-IronPort-AV: E=Sophos;i="4.49,436,1262581200"; 
   d="scan'208";a="83432800"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>, x86@kernel.org
Subject: [PATCH 0/3] x86: slightly unify ret_from_fork
Date: Tue,  9 Feb 2010 15:56:06 +0000
Message-Id: <1265730969-30145-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 09 Feb 2010 15:56:14.0720 (UTC) FILETIME=[6889C000:01CAA9A0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I came across some minor differences between the 32 and 64 bit
implementations of ret_from_fork. Although I don't expect this is code
which can realistically be completely unified there seemed to be some
value in making the two look a bit more similar.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: x86@kernel.org
