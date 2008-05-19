Return-Path: <linux-kernel-owner+w=401wt.eu-S1759266AbYESMb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266AbYESMb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbYESMbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:31:46 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:27605 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbYESMbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:31:45 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080519231.561421028@firstfloor.org>
In-Reply-To: <20080519231.561421028@firstfloor.org>
To: hjk@linutronix.de, corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [11/11] Convert uio to fasync_unlocked
Message-Id: <20080519123120.C7BBD1B41FF@basil.firstfloor.org>
Date: Mon, 19 May 2008 14:31:20 +0200 (CEST)
X-OriginalArrivalTime: 19 May 2008 12:24:18.0828 (UTC) FILETIME=[429E5CC0:01C8B9AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just calls fasync_helper

Cc: hjk@linutronix.de
