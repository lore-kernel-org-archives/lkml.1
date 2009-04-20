Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbZDTN5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbZDTN5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 09:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbZDTN45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 09:56:57 -0400
Received: from lutt.itea.ntnu.no ([129.241.18.234]:58845 "EHLO
	lutt.itea.ntnu.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbZDTN45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 09:56:57 -0400
From: Henrik Austad <henrik@austad.us>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Ziljstra <peterz@infradead.org>
Subject: [RESEND][PATCH 0/2] sched: make the scheduler (even) more modular
Date: Mon, 20 Apr 2009 15:58:59 +0200
Message-Id: <1240235941-1273-1-git-send-email-henrik@austad.us>
X-Mailer: git-send-email 1.6.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several of the functions in the core scheduler tests explicitly for class and 
then to class-specific operations. This should be handled by the sched_class 
interface.

This patch-series moves 2 such elements over to sched_entity, or more precisely, 
the priority part.

henrik

