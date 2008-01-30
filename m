Return-Path: <linux-kernel-owner+w=401wt.eu-S1760999AbYA3NUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760999AbYA3NUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbYA3NUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:20:15 -0500
Received: from ns1.suse.de ([195.135.220.2]:35483 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527AbYA3NUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:20:13 -0500
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Cc: jengelh@computergmbh.de, linux-kernel@vger.kernel.org
Subject: Re: ARP Bug?
From: Andi Kleen <andi@firstfloor.org>
References: <67062.74127.qm@web52004.mail.re2.yahoo.com>
Date: Wed, 30 Jan 2008 14:20:12 +0100
In-Reply-To: <67062.74127.qm@web52004.mail.re2.yahoo.com> (Matti Linnanvuori's message of "Wed\, 30 Jan 2008 04\:44\:17 -0800 \(PST\)")
Message-ID: <p73r6fz5u2b.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matti Linnanvuori <mattilinnanvuori@yahoo.com> writes:
>
> ARP standard. I think it is RFC 826:
> An Ethernet Address Resolution Protocol

The correct standard in this case is RFC1122 and it actually
offers two options for this: the so called strong end host model and the 
weak end host model. Linux can be configured to be both. Default
is the later.

-Andi
