Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbZDGNuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbZDGNuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbZDGNuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:50:11 -0400
Received: from lutt.itea.ntnu.no ([129.241.18.234]:35579 "EHLO
	lutt.itea.ntnu.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbZDGNuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:50:09 -0400
From: Henrik Austad <henrik@austad.us>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Ziljstra <peterz@infradead.org>
Subject: [PATCH 0/2] sched: make the scheduler (even) more modular
Date: Tue,  7 Apr 2009 15:36:11 +0200
Message-Id: <1239111373-12774-1-git-send-email-henrik@austad.us>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several of the functions in the core scheduler tests explicitly for class and 
then to class-specific operations. This should be handled by the sched_class 
interface.

This patch-series moves 2 such elements over to sched_entity, or more precisely, 
the priority part.

Ingo, Peter: I forgot to CC lkml the last time around, sorry about this resend.

