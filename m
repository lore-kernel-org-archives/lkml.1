Return-Path: <linux-kernel-owner+w=401wt.eu-S1760689AbYDDALk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760689AbYDDALk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758097AbYDDAHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:07:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34880 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982AbYDDAHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:07:11 -0400
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
In-Reply-To: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
Cc: Marcus Better <marcus@better.se>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-ID: <pdYe6zNQVl.A.8k.eEW9HB@albercik>
Subject: inconsistent lock state in net_rx_action
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  4 Apr 2008 01:22:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following report is on the current list of known regressions
from 2.6.24.  Please verify if the issue is still present in the
mainline.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10326
Subject		: inconsistent lock state in net_rx_action
Submitter	: Marcus Better <marcus@better.se>
Date		: 2008-03-25 13:21 (10 days old)
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=10326#c20


