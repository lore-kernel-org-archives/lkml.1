Return-Path: <linux-kernel-owner+w=401wt.eu-S1758798AbYFXJxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbYFXJxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 05:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbYFXJxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 05:53:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:54631 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbYFXJxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 05:53:33 -0400
Subject: Re: RT-Scheduler/cgroups: Possible overuse of resources assigned
	via cpu.rt_period_us and cpu.rt_runtime_us
From: Peter Zijlstra <peterz@infradead.org>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: "Daniel K." <dk@uw.no>, mingo@elte.hu,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Jackson <pj@sgi.com>, Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <486090DC.7010705@qualcomm.com>
References: <485917CF.1010401@uw.no> <1213799836.16944.244.camel@twins>
	 <486090DC.7010705@qualcomm.com>
Content-Type: text/plain
Date: Tue, 24 Jun 2008 11:53:05 +0200
Message-Id: <1214301185.4351.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 23:14 -0700, Max Krasnyansky wrote:

> That seems too complicated :). There is no need to mount them separately.

Mounting them independently gives you much greater flexibility.

You quickly run into overlapping cpu sets if you want multiple groups on
the isolated part.



