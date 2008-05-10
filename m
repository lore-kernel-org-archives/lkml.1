Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbYEJN3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbYEJN3n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 09:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbYEJN3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 09:29:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:12306 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069AbYEJN3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 09:29:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cVvPpGATEZWUt0iwOyK+7UJPPJytjoTjVXQO5Rnt3QQNCC1VkxQScMCSxsD4E48rOXalr29FPK8PfZbKsQQF6nJxvIV1J0qLx3Ges9eOZryey6bWEikQx1iBl2ag+c0fXnxpSdlZQxntzP89ueh+r4+Cw7PfaqC6F3DWMt7htRg=
Message-ID: <e2e108260805100629q2cd2aa12w3a7388a34815425c@mail.gmail.com>
Date: Sat, 10 May 2008 15:29:33 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [ANNOUNCE] kmemcheck v7
Cc: "John Reiser" <jreiser@bitwagon.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Daniel Walker" <dwalker@mvista.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, "Josh Aune" <luken@omner.org>,
       "Pekka Paalanen" <pq@iki.fi>
In-Reply-To: <19f34abd0805100502k150e3636x33831230d688dd92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47F630AE.7050801@gmail.com>
	 <e2e108260805100207l13b67706h871f5f1c550e58b3@mail.gmail.com>
	 <482565A5.8010503@cs.helsinki.fi>
	 <e2e108260805100404h63f02194r62e53f79ae2a403f@mail.gmail.com>
	 <19f34abd0805100502k150e3636x33831230d688dd92@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2008 at 2:02 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> However, memory usage doesn't seem to be much of a problem. I actually
> think it might be worth saving the CPU cycles that are needed for the
> lookups/bit operations (memory is cheap, cycles aren't).

Keep in mind that a reduction in memory usage may reduce the number of
cache misses, and that the improved caching behavior may outweigh the
extra CPU cycles needed for the bit operations.

Bart.
