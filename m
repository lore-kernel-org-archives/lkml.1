Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbYBKJfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbYBKJfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYBKJef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:34:35 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:16582 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbYBKJed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:34:33 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <200802111034.764275766@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/8] Various kernel mapping bug fixes
Date: Mon, 11 Feb 2008 10:34:28 +0100 (CET)
X-OriginalArrivalTime: 11 Feb 2008 09:28:08.0318 (UTC) FILETIME=[699F09E0:01C86C90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Relative to git-x86#mm 05afd57b4438d4650d93e6f54f465b0cdd2d9ea8) 

The first bug fix is the most important one -- it fixes a boot hang
on gbpages systems -- the rest is for random issues I found while looking 
at the code. Several are related to EFI (see caveats in the descriptions), 
which looks very broken currently without these patches, but definitely 
needs more testing.

-Andi
