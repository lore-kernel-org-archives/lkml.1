Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbZAFTBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbZAFTBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 14:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbZAFTBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 14:01:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48126
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751470AbZAFTBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 14:01:12 -0500
Date: Tue, 06 Jan 2009 11:01:14 -0800 (PST)
Message-Id: <20090106.110114.103656110.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org, srostedt@redhat.com,
       mingo@elte.hu, sparclinux@vger.kernel.org
Subject: Re: ftrace breaks sparc64 build
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.1.10.0901061342570.10871@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901051458460.25066@gandalf.stny.rr.com>
	<20090106.103234.163615537.davem@davemloft.net>
	<alpine.DEB.1.10.0901061342570.10871@gandalf.stny.rr.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 6 Jan 2009 13:52:36 -0500 (EST)

> I would hate to black list archs just because it gives warnings.

At the very least arch/sparc should build cleanly now because
I took your ldc.c change
