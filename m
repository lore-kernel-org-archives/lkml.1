Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbXLDUGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbXLDUGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbXLDUGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:06:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbXLDUGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:06:00 -0500
To: Christoph Hellwig <hch@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Mike Mason <mmlnx@us.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, David Smith <dsmith@redhat.com>
Subject: Re: [patch 1/2] Linux Kernel Markers - Support Multiple Probes
References: <20071204181845.895090222@polymtl.ca>
	<20071204182402.940135178@polymtl.ca>
	<20071204185517.GA21568@infradead.org>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 04 Dec 2007 15:03:20 -0500
In-Reply-To: <20071204185517.GA21568@infradead.org> (Christoph Hellwig's message of "Tue, 4 Dec 2007 18:55:18 +0000")
Message-ID: <y0mr6i2z0qf.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Christoph Hellwig <hch@infradead.org> writes:

> I think this is complete overkill.  We should rather get one proper
> tracing infrastructure in tree instead of having multiple hacking ones
> in different places.  Yes, please consider this a NACK ;-)

Multiple handlers for markers makes exactly as much sense as multiple
handlers for colocated kprobes - and the latter we've had for years.

- FChE
