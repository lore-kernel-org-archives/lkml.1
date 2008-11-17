Return-Path: <linux-kernel-owner+w=401wt.eu-S1752221AbYKQNXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbYKQNXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbYKQNX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:23:29 -0500
Received: from ozlabs.org ([203.10.76.45]:39343 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbYKQNX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:23:28 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH RFC] cpu alloc cleanups and implementation improvement
Date: Mon, 17 Nov 2008 23:53:17 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811172353.18356.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

  I've argued with Christoph that his implementation contains gratuitous 
obsolescence of perfectly-good APIs; hopefully providing real patches will 
give us a more useful debate.

  It's in easy stages.  There are three general cleanup patches, then four 
patches to expose the current module percpu allocator as a the general dynamic 
percpu allocator, then documentation, a new __get_cpu_ptr() primitive and 
finally a test patch.

I hope this adds some light,
Rusty.
