Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbZELR2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbZELR2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 13:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbZELR2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 13:28:42 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:47920 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753685AbZELR2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 13:28:41 -0400
Date: Tue, 12 May 2009 17:14:01 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       Dave Hansen <dave@linux.vnet.ibm.com>, San Mehat <san@android.com>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Misleading OOM messages
In-Reply-To: <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0905121708470.14226@qirst.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While we are at it: Could we get rid of the name "Out of Memory" and stop
printing texts to that effect? What we call an OOM is a failure to
perform memory reclaim or we are running out of reserves due
to not being able to run reclaim. Mostly this is due to OS internal issues
having nothing to do actual amounts of memory available.

I have seen scores of people put more memory into their boxes because
they thought they did not have enough memory. Then there are those that
lower ulimit values so that users cannot allocate so much memory.


