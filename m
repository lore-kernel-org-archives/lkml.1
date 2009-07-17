Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbZGQTwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbZGQTwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 15:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbZGQTwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 15:52:34 -0400
Received: from cobra.newdream.net ([66.33.216.30]:33647 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbZGQTwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 15:52:33 -0400
Date: Fri, 17 Jul 2009 12:52:33 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/20] ceph: debugging
In-Reply-To: <20090717185641.GH8046@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0907171247570.23194@cobra.newdream.net>
References: <1247693090-27796-13-git-send-email-sage@newdream.net>
 <1247693090-27796-14-git-send-email-sage@newdream.net>
 <1247693090-27796-15-git-send-email-sage@newdream.net>
 <1247693090-27796-16-git-send-email-sage@newdream.net>
 <1247693090-27796-17-git-send-email-sage@newdream.net>
 <1247693090-27796-18-git-send-email-sage@newdream.net>
 <1247693090-27796-19-git-send-email-sage@newdream.net> <87d480x16p.fsf@basil.nowhere.org>
 <Pine.LNX.4.64.0907161014330.8026@cobra.newdream.net>
 <Pine.LNX.4.64.0907171010470.23194@cobra.newdream.net>
 <20090717185641.GH8046@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009, Andi Kleen wrote:
> Good.
> 
> Sorry for not doing more (and more serious) reviews, not enough
> time right now.

You've been helpful nonetheless, thanks! :)

> > #define _dout(fmt, args...)						\
> > 	pr_debug(" %12.12s:%-4d : " fmt "%s",				\
> > 		 ceph_file_part(__FILE__, sizeof(__FILE__)),		\
> > 		 __LINE__, args);
> 
> That seems like a wasteful way to do this -- i bet you could
> shrink binary size with debugging on considerably if you move
> the file_part into a function.

If you mean ceph_file_part shouldn't be inline, definitely.  Beyond that 
I'm not sure what more to change... it's just a few extra chars on the 
format string and 2 calls instead of 1?

sage
