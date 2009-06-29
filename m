Return-Path: <linux-kernel-owner+w=401wt.eu-S1758693AbZF2K6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693AbZF2K6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 06:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZF2K6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 06:58:41 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:49226 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751736AbZF2K6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 06:58:41 -0400
Subject: Re: kmemleak hexdump proposal
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20090629104553.GA3731@localdomain.by>
References: <20090628173632.GA3890@localdomain.by>
	 <84144f020906290243u7a362465p6b1f566257fa3239@mail.gmail.com>
	 <20090629101917.GA3093@localdomain.by>
	 <1246270774.6364.9.camel@penberg-laptop>
	 <20090629104553.GA3731@localdomain.by>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 29 Jun 2009 11:58:28 +0100
Message-Id: <1246273108.21450.19.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jun 2009 10:58:29.0833 (UTC) FILETIME=[894A9390:01C9F8A8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-29 at 13:45 +0300, Sergey Senozhatsky wrote:
> BTW, printing it all the time we can spam kmemleak (in case there are objects sized 2K, 4K and so on).
> That's why I wrote about hexdump=OBJECT_POINTER.

I'm more in favour of an on/off hexdump feature (maybe even permanently
on) and with a limit to the number of bytes it displays. For larger
blocks, the hexdump=OBJECT_POINTER is easily achievable in user space
via /dev/kmem.

My proposal is for an always on hexdump but with no more than 2-3 lines
of hex values. As Pekka said, I should get it into linux-next before the
next merging window.

-- 
Catalin

