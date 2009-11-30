Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZK3TDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZK3TDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 14:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZK3TDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 14:03:10 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:51350 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbZK3TDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 14:03:09 -0500
Date: Mon, 30 Nov 2009 13:01:45 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [Patch] percpu: remove two suspicious break statements
In-Reply-To: <4B13A7ED.9010905@kernel.org>
Message-ID: <alpine.DEB.2.00.0911301258370.18682@router.home>
References: <20091130091501.4507.28683.sendpatchset@localhost.localdomain> <4B13A7ED.9010905@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009, Tejun Heo wrote:

> That actually is correct code.  It's checking whether the first
> iteration covers the whole thing.  I thought the comment there

A loop statement that never creates a loop? You either execute a goto or a break.

Some more elaborate documentation is needed.


