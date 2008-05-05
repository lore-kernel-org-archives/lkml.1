Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbYEETyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbYEETyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbYEETyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:54:11 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53059 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336AbYEETyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:54:10 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <481F62BC.3050605@s5r6.in-berlin.de>
Date: Mon, 05 May 2008 21:40:44 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       sfrench@us.ibm.com, swhiteho@redhat.com, jeff@garzik.org,
       ralf@linux-mips.org, drzeus-list@drzeus.cx, jack@ucw.cz, cbou@mail.ru,
       jens.axboe@oracle.com, ericvh@gmail.com, wim@iguana.be,
       chris@zankel.net, nico@cam.org, clameter@sgi.com, ezk@cs.sunysb.edu,
       linux-kernel@vger.kernel.org
Subject: Re: git trees which are not yet in linux-next
References: <20080502151206.b40f77ea.akpm@linux-foundation.org> <84144f020805051116mdbbea01q39f17bce95c95dbb@mail.gmail.com> <20080505113128.d68863a2.akpm@linux-foundation.org> <Pine.LNX.4.64.0805052136530.5570@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0805052136530.5570@sbz-30.cs.Helsinki.FI>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg wrote:
> Well, I only really have three kinds of patches: (1) testing, (2) 
> for-linus asap (fixes in the middle of a release cycle) and (3) for-linus 
> when the merge window opens. Up until now, I've put (1) in for-mm and 
> after enough exposure (and no bug reports) they graduate into (2) or (3).
> 
> So the problem here is where I put the patches in category (1)?

(1) Testing = (1a) testing isolated changes, (1b) testing in integration 
with other pending changes.  -next is for the latter kind of tests, 
AFAIU with the primary goal of sorting out integration related issues. 
For several reasons --- for example one reason which I saw mentioned was 
to attract more testers than maybe -mm had lately --- we have been asked 
to submit code to -next which has passed (1a)-type testing and had 
appropriate review.

Needless to say, many of us have difficulties to acquire resources 
[time, hardware, test cases/ workloads] for (1) or (1a).  OTOH, 
borrowing -next or -mm for too early test stages will not pay out for 
any of us in the long run.
-- 
Stefan Richter
-=====-==--- -=-= --=-=
http://arcgraph.de/sr/
