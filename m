Return-Path: <linux-kernel-owner+w=401wt.eu-S936946AbXLQU70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936946AbXLQU70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761350AbXLQU7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 15:59:16 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:2887 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759608AbXLQU7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 15:59:14 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Theodore Tso" <tytso@mit.edu>, <jreiser@bitwagon.com>
Cc: "Matt Mackall" <mpm@selenic.com>, <linux-kernel@vger.kernel.org>,
       <security@kernel.org>
Subject: RE: /dev/urandom uses uninit bytes, leaks user data
Date: Mon, 17 Dec 2007 12:59:04 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKAELOIOAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <4766A40D.4080804@BitWagon.com>
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 17 Dec 2007 13:00:20 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 17 Dec 2007 13:00:22 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The bottom line:  At a cost of at most three unpredictable branches
> (whether to clear the bytes in the last word with indices congruent
> to 1, 2, or 3 modulo 4), then the code can reduce the risk from something
> small but positive, to zero.  This is very inexpensive insurance.

> John Reiser, jreiser@BitWagon.com

Even if you're right, the change isn't free. You've simply presented
evidence of one non-zero benefit of it. You've given no ability to assess
the size of this benefit and no way to figure if it exceeds the cost. There
is also a non-zero *security* cost to this change.

DS


