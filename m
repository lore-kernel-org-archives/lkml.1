Return-Path: <linux-kernel-owner+w=401wt.eu-S1758817AbXKMPdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbXKMPdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 10:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758941AbXKMPdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 10:33:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43471 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbXKMPdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 10:33:39 -0500
Subject: Re: [RFC] Add markers into semaphore primitives
From: Peter Zijlstra <peterz@infradead.org>
To: "David J. Wilder" <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1194915156.913.4.camel@lc4eb748232119.ibm.com>
References: <1194915156.913.4.camel@lc4eb748232119.ibm.com>
Content-Type: text/plain
Date: Tue, 13 Nov 2007 16:33:34 +0100
Message-Id: <1194968014.8255.23.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-11-12 at 16:52 -0800, David J. Wilder wrote:
> This patch adds several markers around semaphore primitives.
> Along with a tracing application this patch can be useful for measuring
> kernel semaphore usage and contention.

It would be much better to help in eradicating every last semaphore user
and then these statistics will be provided by lockstat.


