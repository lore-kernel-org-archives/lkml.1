Return-Path: <linux-kernel-owner+w=401wt.eu-S1761271AbXEaMqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761271AbXEaMqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 08:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbXEaMqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 08:46:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56706 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbXEaMqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 08:46:11 -0400
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/9] Conditional Calls - Hash Table
References: <20070530140025.917261793@polymtl.ca>
	<20070530140227.398040643@polymtl.ca>
From: Andi Kleen <andi@firstfloor.org>
Date: 31 May 2007 15:42:50 +0200
In-Reply-To: <20070530140227.398040643@polymtl.ca>
Message-ID: <p731wgxds85.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:

> Reimplementation of the cond calls which uses a hash table to hold the active
> cond_calls. It permits to first arm a cond_call and then load supplementary
> modules that contain this cond_call.

Hash table is probably overkill. This is a very very slow path operation.
Can you simplify the code? Just a linked list of all the condcall segments
should be enough  and then walk it.

-Andi
