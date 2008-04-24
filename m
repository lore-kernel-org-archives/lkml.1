Return-Path: <linux-kernel-owner+w=401wt.eu-S1763423AbYDXUKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763423AbYDXUKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 16:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760057AbYDXUJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 16:09:58 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:4227 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759056AbYDXUJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 16:09:57 -0400
X-Greylist: delayed 559 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2008 16:09:57 EDT
From: James Cloos <cloos@jhcloos.com>
To: linux-kernel@vger.kernel.org
Subject: Regression: starting X locks box with git master
User-Agent: Gnus/5.110007 (No Gnus v0.7) Emacs/23.0.60 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2007 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
X-Hashcash: 1:23:080424:linux-kernel@vger.kernel.org::Qe2KxK2fsNSZWLzl:0000000000000000000000000000000000uNf
Date: Thu, 24 Apr 2008 15:59:49 -0400
Message-ID: <m3hcdrqb03.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3dc5063786b273f1aee545844f6bd4e9651ebffe was current when I compiled.

With that kernel, my laptop locks up as soon as I startx.

The Xorg.0.log showed that the radeon driver got as far as starting
the i2c calls to the M7 video card.

After that the box would reply to ICMP pings and SysRq-B, but was
otherwise non-responsive.  Even SysRq-[KSU] seemed to do nothing.

v2.6.25 works fine.

There are 3562 commits (including merges) between those two, and
it takes an hour or more for each kernel compile.  Bisecting will
be quite painful.  And I only have the one box to work on.  But I
will see what I can do.

Posting before bisecting in case it helps anyone else....

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6


