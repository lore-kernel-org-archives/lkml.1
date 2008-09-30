Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbYI3Rju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbYI3Rju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 13:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYI3Rjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 13:39:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:34610 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbYI3Rjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 13:39:41 -0400
Message-ID: <48E26400.8020604@kernel.org>
Date: Wed, 01 Oct 2008 02:38:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Robert Krawitz <rlk@alum.mit.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Another one for fixup-storage
References: <4897809E.8070902@alum.mit.edu> <48E25D6D.30504@kernel.org> <200809301734.m8UHY5lg027393@dsl092-065-009.bos1.dsl.speakeasy.net>
In-Reply-To: <200809301734.m8UHY5lg027393@dsl092-065-009.bos1.dsl.speakeasy.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 30 Sep 2008 17:39:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Robert Krawitz wrote:
>    Date: Wed, 01 Oct 2008 02:10:05 +0900
>    From: Tejun Heo <tj@kernel.org>
> 
>    Robert Krawitz wrote:
>    > This is for a Dell Inspiron E1705/9400.  I'm using a non-OEM disk (a
>    > Hitachi 320 GB drive).
> 
>    Just one more question.  What do you mean by non-OEM?  It didn't come
>    with the listed harddrive?
> 
> Correct.  I purchased and installed the hard drive after I bought the
> laptop.

Ah... thanks.  I Robert's case is like that too and I don't think
storage-fixup is the right place to deal with that.  It seems we'll need
something which is somewhat intelligent and more dynamic.  I'll talk
with Bruce whether we can do something about it using smartd.

Thanks.

-- 
tejun
