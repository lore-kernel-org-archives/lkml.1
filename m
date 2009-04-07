Return-Path: <linux-kernel-owner+w=401wt.eu-S1761084AbZDGVyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761084AbZDGVyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757060AbZDGVx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:53:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52863 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716AbZDGVx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:53:58 -0400
Date: Tue, 7 Apr 2009 23:56:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [5/16] POISON: Add support for poison swap entries
Message-ID: <20090407215605.GZ17934@one.firstfloor.org>
References: <20090407509.382219156@firstfloor.org> <20090407151002.0AA8F1D046E@basil.firstfloor.org> <alpine.DEB.1.10.0904071710500.12192@qirst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904071710500.12192@qirst.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 05:11:26PM -0400, Christoph Lameter wrote:
> 
> Could you separate the semantic changes to flag checking for migration

You mean to try_to_unmap? 

> out for easier review?

That's already done. The first patch doesn't change any semantics,
just flags/action checking.  Or rather any semantics change in there
would be a bug.

Only the two later ttu patches add to the semantics.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
