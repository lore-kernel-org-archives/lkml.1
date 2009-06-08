Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbZFHUuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbZFHUuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 16:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbZFHUuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 16:50:07 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:55685 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751130AbZFHUuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 16:50:06 -0400
Date: Mon, 8 Jun 2009 16:49:45 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Robin Holt <holt@sgi.com>
cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, mingo@elte.hu,
       rusty@rustcorp.com.au, davem@davemloft.net
Subject: Re: [this_cpu_xx 04/11] Use this_cpu ops for network statistics
In-Reply-To: <20090608112736.GL29447@sgi.com>
Message-ID: <alpine.DEB.1.10.0906081649020.12271@gentwo.org>
References: <20090605191819.376530498@gentwo.org> <20090605191851.012334412@gentwo.org> <20090608112736.GL29447@sgi.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009, Robin Holt wrote:

> > +	this_cpu_inc((net)->ct.stat->count)
>
> Why not put this on one line?
> #define NF_CT_STAT_INC_ATOMIC(net, count)  this_cpu_inc((net)->ct.stat->count)

Would be more than 78 characters in a line.

