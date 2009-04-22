Return-Path: <linux-kernel-owner+w=401wt.eu-S1752952AbZDVPKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbZDVPKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 11:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbZDVPKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 11:10:08 -0400
Received: from ns.ariel-networks.com ([122.216.114.210]:40425 "EHLO
	ns.ariel-networks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZDVPKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 11:10:07 -0400
X-Greylist: delayed 1155 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Apr 2009 11:10:07 EDT
To: linux-kernel@vger.kernel.org
Subject: Question : internal processing of block I/O queue
Message-Id: <20090422145050.C00333780DD@ns.ariel-networks.com>
Date: Wed, 22 Apr 2009 23:50:50 +0900 (JST)
From: ohyama_sec@ariel-networks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroyasu OHYAMA

I'm a student of Japan, and I diddle the Linux for joyment.
Could I ask you a question about block I/O.

The question is that "Does The linux block I/O processing follow a first-in first-out order"

Now, I'm making layer under low level filesystem. And I wonna make it work as Cache of data like page cache.
I could understood if I emit block I/O request with submit_bio(), the kernel delay it, and I could notice the result by .bi_end_io() method that I set.

But I have something on my mind. "Does the kernel assure the order of block I/O ?"

Once I issue a block I/O request to common I/O layer, the I/O processing is delayed. And the actual block I/O processing is executed by kernel thread.
So user who commit block I/O never have to mind the sequence of delayed block I/O requests.
But I want to know that "The block I/O processing executed first is executed earlient, or may not".

If a I/O request issued back is issued earlier than before, I have to protect the target block that is issued block I/O request.

Could you please give me the actuall operation of block I/O component, that is "It may happen, or not".

Thank you in advance.
