Return-Path: <linux-kernel-owner+w=401wt.eu-S1751574AbZGQS4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbZGQS4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 14:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZGQS4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 14:56:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57766 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbZGQS4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 14:56:45 -0400
Date: Fri, 17 Jul 2009 20:56:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sage Weil <sage@newdream.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/20] ceph: debugging
Message-ID: <20090717185641.GH8046@one.firstfloor.org>
References: <1247693090-27796-13-git-send-email-sage@newdream.net> <1247693090-27796-14-git-send-email-sage@newdream.net> <1247693090-27796-15-git-send-email-sage@newdream.net> <1247693090-27796-16-git-send-email-sage@newdream.net> <1247693090-27796-17-git-send-email-sage@newdream.net> <1247693090-27796-18-git-send-email-sage@newdream.net> <1247693090-27796-19-git-send-email-sage@newdream.net> <87d480x16p.fsf@basil.nowhere.org> <Pine.LNX.4.64.0907161014330.8026@cobra.newdream.net> <Pine.LNX.4.64.0907171010470.23194@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907171010470.23194@cobra.newdream.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good.

Sorry for not doing more (and more serious) reviews, not enough
time right now.

> #define _dout(fmt, args...)						\
> 	pr_debug(" %12.12s:%-4d : " fmt "%s",				\
> 		 ceph_file_part(__FILE__, sizeof(__FILE__)),		\
> 		 __LINE__, args);

That seems like a wasteful way to do this -- i bet you could
shrink binary size with debugging on considerably if you move
the file_part into a function.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
