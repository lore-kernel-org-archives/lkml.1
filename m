Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbZJARDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbZJARDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 13:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755723AbZJARDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 13:03:07 -0400
Received: from emailgw03.pnl.gov ([192.101.109.31]:10113 "EHLO
	emailgw03.pnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716AbZJARDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 13:03:07 -0400
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Oct 2009 13:03:06 EDT
X-IronPort-AV: E=Sophos;i="4.44,488,1249282800"; 
   d="scan'208";a="9249320"
Subject: Process creation & deletion notification
From: Kevin Fox <Kevin.Fox@pnl.gov>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 01 Oct 2009 09:02:55 -0700
Message-Id: <1254412976.21697.11.camel@sledge.emsl.pnl.gov>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a reliable way for a user space application to get
notifications every time a process is created and deleted?

I have been playing with the Connector code + PROC_EVENTS and it seems
to do what I want, but I'm not sure about two things:

1. Will the creations and deletions ever come out of order. I need a
childs creation to always come before a its parents deletion.
2. Will it ever drop a creation or deletion message. I depend on getting
every creation/deletion.

If the Connector code using PROC_EVENTS can't meet those requirements,
could someone please recommend something else to use?

Thanks,
Kevin



