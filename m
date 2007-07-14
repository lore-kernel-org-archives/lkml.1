Return-Path: <linux-kernel-owner+w=401wt.eu-S1763391AbXGNAlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763391AbXGNAlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 20:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757266AbXGNAl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 20:41:29 -0400
Received: from que03.charter.net ([209.225.8.191]:44761 "EHLO
	que03.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876AbXGNAl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 20:41:28 -0400
Message-ID: <46981580.5000008@charter.net>
Date: Fri, 13 Jul 2007 19:14:56 -0500
From: Jerry Cooperstein <jerry.cooperstein@charter.net>
User-Agent: Thunderbird 1.5.0.12 (X11/20070529)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: mutex_unlock() in interrupt context
References: <20070713160117.0db9d36d.akpm@linux-foundation.org>	<0C7297FA1D2D244A9C7F6959C0BF1E5202234496@azsmsx413.amr.corp.intel.com> <20070713170147.6129fc3b.akpm@linux-foundation.org>
In-Reply-To: <20070713170147.6129fc3b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Chzlrs: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/mutex.c says about mutex_unlock():

  * This function must not be used in interrupt context.

However I have done some simple test cases that show
it works without complaint.  Now I understand that one
shouldn't do this for good reasons.  So is this a
good coding practice rule, but something that
could appear in sloppy or poorly designed code?

Jerry Cooperstein
  Axian, Inc., Software Consulting and Training

