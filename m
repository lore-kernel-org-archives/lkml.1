Return-Path: <linux-kernel-owner+w=401wt.eu-S1752471AbXISUBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbXISUBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 16:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbXISUBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 16:01:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbXISUBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 16:01:15 -0400
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, dsmith@redhat.com,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] Linux Kernel Markers - Architecture Independent Code
References: <20070918211324.161373216@polymtl.ca>
	<20070918211459.193904061@polymtl.ca> <20070919113737.GA18177@Krystal>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Wed, 19 Sep 2007 09:53:10 -0400
In-Reply-To: <20070919113737.GA18177@Krystal> (Mathieu Desnoyers's message of "Wed, 19 Sep 2007 07:37:38 -0400")
Message-ID: <y0mtzpqvk1l.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:

> [...]  Do you think I should also remove the __markers_strings
> section from here ?

Current systemtap marker support code relies on the __markers_strings
section.

- FChE
