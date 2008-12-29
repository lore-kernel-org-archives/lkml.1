Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680AbYL2SyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbYL2SyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 13:54:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYL2Sxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 13:53:53 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:50509 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbYL2Sxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 13:53:52 -0500
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 0/2] futex_key reference accounting fixes
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Date: Mon, 29 Dec 2008 10:53:49 -0800
Message-ID: <20081229185238.10342.75651.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series fixes several problems with symmetric reference counting of the
futex keys.

---

Darren Hart (2):
      futex: correct futex_requeue futex key ref counting in requeue loop
      futex: make futex_(get|put)_key() calls symmetric


 kernel/futex.c |   68 ++++++++++++++++++++++++++++++--------------------------
 1 files changed, 36 insertions(+), 32 deletions(-)

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
