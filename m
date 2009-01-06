Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbZAFHBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbZAFHBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 02:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbZAFHBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 02:01:03 -0500
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:62181 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbZAFHBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 02:01:02 -0500
From: Junio C Hamano <gitster@pobox.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
References: <alpine.LFD.2.00.0901051839330.3057@localhost.localdomain>
 <20090105.201530.195720489.davem@davemloft.net>
 <alpine.LFD.2.00.0901052029220.3057@localhost.localdomain>
 <20090105.204934.65827705.davem@davemloft.net>
Date: Mon, 05 Jan 2009 23:00:53 -0800
In-Reply-To: <20090105.204934.65827705.davem@davemloft.net> (David Miller's
 message of "Mon, 05 Jan 2009 20:49:34 -0800 (PST)")
Message-ID: <7v7i58or4q.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: C6F2F29C-DBBF-11DD-84BD-5720C92D7133-77302942!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> That wouldn't have helped me in this case at all.
>
> I had 4 firmware patches to apply, each one had to add entries
> to the same file.
>
> The first patch had to be skipped.
>
> So the second one, which is the first one I added (which is the acenic
> bogon with the missed delete), is the one GIT wouldn't take but patch
> would.

What I typically do when I see myself in such a situation is to apply all
of four patches to a throw-away branch once, and then discard that branch
right away.  Then I can apply only the good three patches, skipping the
first one, and "am -3" would still apply.
