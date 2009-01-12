Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbZALWOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbZALWOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbZALWN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:13:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751556AbZALWN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:13:58 -0500
Date: Mon, 12 Jan 2009 14:12:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Clifford Wolf <clifford@clifford.at>
Cc: linux-kernel@vger.kernel.org, i2c@lm-sensors.org, khali@linux-fr.org,
       adrian@humboldt.co.uk, linux-i2c@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH] Incremental i2c-mpc driver fix for multi-master i2c
 busses.
Message-Id: <20090112141200.ca89caab.akpm@linux-foundation.org>
In-Reply-To: <20090105132102.GA27855@clifford.at>
References: <20090105132102.GA27855@clifford.at>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009 14:21:02 +0100
Clifford Wolf <clifford@clifford.at> wrote:

> Incremental i2c-mpc driver fix for multi-master i2c busses.
> 
> This is an incremental bugfix for the i2c-mpc driver. It is based
> on the bugfix I've sent on 2008-12-22:
> 
> 	http://lkml.org/lkml/2008/12/22/99
> 
> There still was a remaining problem with multi-master i2c busses
> when an i2c bus access is interrupted by a unix signal while
> waiting for bus arbitration.
> 
> This is an extreamly rare case but I managed to stumble over it in
> multi master i2c performance tests.
> 
> Tested with a freescale MPC8349E host cpu.

That's not a very good changelog - it has basically no information,
apart from the linked-to original changelog.

And the linked-to changelog has no description of the bug which is
being fixed.

> --- drivers/i2c/busses/i2c-mpc.c	(revision 2216)
> +++ drivers/i2c/busses/i2c-mpc.c	(working copy)

Please prepare patches in `patch -p1' form:

--- a/drivers/i2c/busses/i2c-mpc.c
+++ a/drivers/i2c/busses/i2c-mpc.c

