Return-Path: <linux-kernel-owner+w=401wt.eu-S1762235AbZFPVDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762235AbZFPVDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbZFPVDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:03:34 -0400
Received: from emailgw04.pnl.gov ([192.101.109.35]:26723 "EHLO
	emailgw04.pnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbZFPVDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:03:34 -0400
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jun 2009 17:03:34 EDT
X-IronPort-AV: E=Sophos;i="4.42,231,1243839600"; 
   d="scan'208";a="5505132"
Subject: unix socket fd sending questions
From: Kevin Fox <Kevin.Fox@pnl.gov>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 16 Jun 2009 13:00:36 -0700
Message-Id: <1245182436.6737.637.camel@sledge.emsl.pnl.gov>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Say you were to open a directory handle in process A and pass it through
a unix socket to process B.

Process A and B are owned by two different users and are running in two
separate mount namespaces.

If you were to readdir in process B on the descriptor would you see
process A's view of the world? I'm guessing probably so.

If you were to walk the tree pointed to by the descriptor, would you see
A's view of the world? I'm guessing not if you use open/readdir, but
what about openat and the like?

Thanks,
Kevin Fox

