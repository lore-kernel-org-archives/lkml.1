Return-Path: <linux-kernel-owner+w=401wt.eu-S1761705AbXGKJxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761705AbXGKJxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757675AbXGKJxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:53:34 -0400
Received: from styx.suse.cz ([82.119.242.94]:46983 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756203AbXGKJxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:53:33 -0400
Date: Wed, 11 Jul 2007 11:58:05 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Chuck Ebbert <cebbert@redhat.com>, Jan Kratochvil <honza@jikos.cz>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Ernie Petrides <petrides@redhat.com>
Subject: Re: [PATCH][RESEND] PIE randomization
In-Reply-To: <20070710094730.GH7012@devserv.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.0707111157290.11634@jikos.suse.cz>
References: <20070522161642.b71ddacb.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705231044540.22906@jikos.suse.cz> <20070704082554.GQ7012@devserv.devel.redhat.com>
 <Pine.LNX.4.64.0707041927090.11634@jikos.suse.cz> <468D5A3A.1010306@redhat.com>
 <468D5B28.8080308@redhat.com> <Pine.LNX.4.64.0707070205460.11634@jikos.suse.cz>
 <20070707123004.GZ7012@devserv.devel.redhat.com> <Pine.LNX.4.64.0707091333230.11634@jikos.suse.cz>
 <Pine.LNX.4.64.0707092356450.11634@jikos.suse.cz> <20070710094730.GH7012@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Jakub Jelinek wrote:

> Restore BAD_ADDR check strictness, use IS_ERR in the only place where
> the stricter BAD_ADDR can't work, as the value is a load bias rather
> than userland address.
> Signed-off-by: Jakub Jelinek <jakub@redhat.com>

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Andrew, fold this into pie-randomization.patch if possible please. Thanks,

-- 
Jiri Kosina
SUSE Labs
