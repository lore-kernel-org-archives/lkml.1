Return-Path: <linux-kernel-owner+w=401wt.eu-S1751801AbYLXWF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbYLXWF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 17:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYLXWFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 17:05:47 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34031 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbYLXWFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 17:05:47 -0500
Date: Wed, 24 Dec 2008 23:03:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 3/7][v4] Define siginfo_from_ancestor_ns()
Message-ID: <20081224220358.GA3851@redhat.com>
References: <20081224114414.GA7879@us.ibm.com> <20081224115124.GC8020@us.ibm.com> <20081224162823.GE11593@redhat.com> <20081224212426.GD13502@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081224212426.GD13502@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24, Sukadev Bhattiprolu wrote:
>
> Oleg Nesterov [oleg@redhat.com] wrote:
> | And, SI_ASYNCIO only matters when we send the signal to the subnamespace,
> | and in that case we will probably mangle .si_pid. So why don't we warn
> | when .si_code == SI_USER?
>
> I was wondering if I should there too :-) But what do you think ?

Well, if you ask me, I'd suggest to document the problems with
sigqueueinfo() and forget. Whatever we do, we can't be always
right.

Oleg.

