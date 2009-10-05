Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbZJETAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbZJETAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 15:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbZJETAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 15:00:48 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:1563 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465AbZJETAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 15:00:47 -0400
From: James Cloos <cloos@jhcloos.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.32-rc3
In-Reply-To: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> (Linus
	Torvalds's message of "Sun, 4 Oct 2009 17:44:43 -0700 (PDT)")
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.50 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Mon, 05 Oct 2009 14:55:40 -0400
Message-ID: <m3y6npacvv.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:29:091005:linux-kernel@vger.kernel.org::0g+NSoxKVxLJpTMA:00000000000000000000000000000000qcRiI
X-Hashcash: 1:29:091005:torvalds@linux-foundation.org::y2FI1dX9nvosLcO1:0000000000000000000000000000000flssJ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote earlier, in a reply on the Poor desktop responsiveness with
background I/O-operations thread, that sometime between .30-rc6 and
the .31 tag all of the recent improvements in perceived performance
has been lost.

I'm happy to report that as of the cmpexch64 fix, that regression
is gone.  Performance under load -- and particularly with significant
paging -- shows a vast improvement (on my aging, 32-bit laptop).

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
