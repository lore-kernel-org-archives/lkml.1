Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbYJGNaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbYJGNaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 09:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbYJGN3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 09:29:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753326AbYJGN3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:29:54 -0400
Message-ID: <48EB63D5.8090202@linux-foundation.org>
Date: Tue, 07 Oct 2008 08:27:49 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, ebiederm@xmission.com,
       travis@sgi.com, herbert@gondor.apana.org.au, xemul@openvz.org,
       penberg@cs.helsinki.fi
Subject: Re: [patch 3/4] cpu alloc: The allocator
References: <20080929193500.470295078@quilx.com> <20081003003342.4d592c1f.akpm@linux-foundation.org> <48E614A0.60209@linux-foundation.org> <200810060810.43511.rusty@rustcorp.com.au>
In-Reply-To: <200810060810.43511.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:

> It shouldn't be a big win, since possible ~= online for most systems.  And 
> having all the per-cpu users register online and offline cpu callbacks is 
> error prone and a PITA.

That also has the nice consequence that moving the allocators (page allocator
/ slub) to the use of cpu_alloc will avoid the online and offline callbacks
(the main focus of these is getting rid of large pointer arrays there and
simplifying bootstrap etc).



