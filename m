Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317Ab0AGRGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab0AGRGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 12:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126Ab0AGRGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 12:06:05 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:35405 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab0AGRGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 12:06:02 -0500
Date: Thu, 7 Jan 2010 11:05:21 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC local_t removal V1 0/4] Remove local_t
In-Reply-To: <20100105224516.GA32584@Krystal>
Message-ID: <alpine.DEB.2.00.1001071103530.901@router.home>
References: <20100105220417.400092933@quilx.com> <20100105222351.GA29675@Krystal> <alpine.DEB.2.00.1001051629550.9108@router.home> <20100105224516.GA32584@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010, Mathieu Desnoyers wrote:

> > Volatile is discouraged as far as I can tell.
>
> If you want to ensure that a simple variable assignment or read
> (local_set, local_read) are not performed piecewise by the compiler
> which can cause odd effects when shared with interrupt handlers, this
> will however be necessary.

Piecewise? Assignment of scalars or a pointer is an atomic operation by
default. Lots of things will break if that is not true.
