Return-Path: <linux-kernel-owner+w=401wt.eu-S1759958AbZDGQGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958AbZDGQGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 12:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756208AbZDGQGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 12:06:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35539 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708AbZDGQGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 12:06:10 -0400
Message-ID: <49DB7934.3060008@redhat.com>
Date: Tue, 07 Apr 2009 12:03:00 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: hugh@veritas.com, npiggin@suse.de, lee.schermerhorn@hp.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [13/16] POISON: The high level memory error handler in
 the VM
References: <20090407509.382219156@firstfloor.org> <20090407151010.E72A91D0471@basil.firstfloor.org>
In-Reply-To: <20090407151010.E72A91D0471@basil.firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:

> This is rather tricky code and needs a lot of review. Undoubtedly it still
> has bugs.

It's just complex enough that it looks like it might have
more bugs, but I sure couldn't find any.

Hitting a bug in this code seems favorable to hitting
guaranteed memory corruption, so I hope Andrew or Ingo
will merge this into one of their trees.

> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
