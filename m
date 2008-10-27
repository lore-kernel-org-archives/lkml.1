Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbYJ0XNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbYJ0XNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 19:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYJ0XNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 19:13:38 -0400
Received: from ozlabs.org ([203.10.76.45]:59875 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbYJ0XNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 19:13:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18694.19224.210495.372922@cargo.ozlabs.ibm.com>
Date: Tue, 28 Oct 2008 10:13:28 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip/tracing/markers] new probes manager
In-Reply-To: <20081027182655.GA11494@elte.hu>
References: <48FFE5CB.2050608@cn.fujitsu.com>
	<20081027155832.GB17250@Krystal>
	<20081027163046.GA20692@Krystal>
	<20081027182655.GA11494@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> yes, the statement that rmb() is very expensive looks dubious. It is 
> absolutely cheap everywhere.

On x86, maybe.  On powerpc it's as expensive as mb().

Paul.
