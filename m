Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbYDDBHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbYDDBHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 21:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbYDDBGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 21:06:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34586
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755846AbYDDBGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 21:06:54 -0400
Date: Thu, 03 Apr 2008 18:06:54 -0700 (PDT)
Message-Id: <20080403.180654.54935934.davem@davemloft.net>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, marcus@better.se
Subject: Re: inconsistent lock state in net_rx_action
From: David Miller <davem@davemloft.net>
In-Reply-To: <pdYe6zNQVl.A.8k.eEW9HB@albercik>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
	<pdYe6zNQVl.A.8k.eEW9HB@albercik>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Fri,  4 Apr 2008 01:22:43 +0200 (CEST)

> The following report is on the current list of known regressions
> from 2.6.24.  Please verify if the issue is still present in the
> mainline.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10326
> Subject		: inconsistent lock state in net_rx_action
> Submitter	: Marcus Better <marcus@better.se>
> Date		: 2008-03-25 13:21 (10 days old)
> Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=10326#c20

The patch in the report has been added to the tree
and it fixes this problem.
