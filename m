Return-Path: <linux-kernel-owner+w=401wt.eu-S1161293AbXBHP1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161293AbXBHP1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 10:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbXBHP1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 10:27:37 -0500
Received: from homer.mvista.com ([63.81.120.158]:13434 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbXBHP1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 10:27:37 -0500
Subject: scheduler timing
From: Daniel Walker <dwalker@mvista.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 08 Feb 2007 07:25:55 -0800
Message-Id: <1170948355.19743.41.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


After looking at the scheduler timing I was thinking it might be a fair
trade off to convert sched_clock to return cycles instead of converting
to nanosecond each time it reads .. 

I'm just probing for anyone thoughts on this ..

I'm not promoting a specific implementation, but I would think the
tuning nobs would have to stay in nanosecond, but everything else would
be converted to cycles ..

Daniel

