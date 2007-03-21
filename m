Return-Path: <linux-kernel-owner+w=401wt.eu-S964883AbXCUU1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964883AbXCUU1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 16:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964896AbXCUU1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 16:27:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964883AbXCUU1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 16:27:39 -0400
Message-ID: <4601950D.5000503@redhat.com>
Date: Wed, 21 Mar 2007 16:26:53 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: sky2 still broken in 2.6.20.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Transmit timeouts and locked-up adapters still occur in kernel
2.6.20.3.  It looks like the patch that was applied to 2.6.20.2
is not enough. Unfortunately that one isn't the same as what
went upstream. Looks like it needs to be reverted, then the two
upstream patches applied?
