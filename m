Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbZJFQu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbZJFQu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756855AbZJFQu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:50:26 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:34261 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752078AbZJFQu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:50:26 -0400
Date: Tue, 6 Oct 2009 12:43:33 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: nickpiggin@yahoo.com.au, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, linux-mm@kvack.org
Subject: Re: [patch 4/4] vunmap: Fix racy use of rcu_head
In-Reply-To: <20091006144043.378971387@polymtl.ca>
Message-ID: <alpine.DEB.1.10.0910061241250.18309@gentwo.org>
References: <20091006143727.868480435@polymtl.ca> <20091006144043.378971387@polymtl.ca>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009, Mathieu Desnoyers wrote:

> Simplest fix: directly kfree the data structure rather than doing it lazily.

The delay is necessary as far as I can tell for performance reasons. But
Nick was the last one fiddling around with the subsystem as far as I
remember. CCing him. May be he has a minute to think about a fix that
preserved performance.

