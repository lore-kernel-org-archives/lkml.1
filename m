Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbZJFX42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbZJFX42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 19:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758472AbZJFX42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 19:56:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:32981 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbZJFX41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 19:56:27 -0400
Message-ID: <4ACBD8D7.7040700@kernel.org>
Date: Wed, 07 Oct 2009 08:55:03 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 01/20] Introduce this_cpu_ptr() and generic this_cpu_*
 operations
References: <20091001212521.123389189@gentwo.org> <20091002093453.GA21427@elte.hu> <alpine.DEB.1.10.0910021311440.26189@gentwo.org> <200910062034.40864.rusty@rustcorp.com.au>
In-Reply-To: <200910062034.40864.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 06 Oct 2009 23:55:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Rusty Russell wrote:
> I still think that it's not symmetrical: get_cpu_var implies
> get_cpu_ptr; there's no "this" in any Linux API until now.

Yeah, the naming of percpu related stuff is a big mess. :-( Given that
percpu variables aren't being used too widely at this time, cleaning
up the API is an option.  What do you think?  Any good proposal on
mind?

Thanks.

-- 
tejun
