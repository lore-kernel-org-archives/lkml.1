Return-Path: <linux-kernel-owner+w=401wt.eu-S1751846AbXLHTTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbXLHTTc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 14:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbXLHTTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 14:19:22 -0500
Received: from simmts7.bellnexxia.net ([206.47.199.165]:44119 "EHLO
	simmts7-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413AbXLHTTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 14:19:21 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAG99WkecIsMU/2dsb2JhbAAIkSs
Message-ID: <475AEE30.4070806@gmail.com>
Date: Sat, 08 Dec 2007 15:19:12 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Possible locking issue in viotape.c
References: <20071206021857.826386004@mvista.com>	 <20071206021909.131993721@mvista.com>  <20071206102334.GE17299@elte.hu>	 <1196958847.1568.98.camel@jnielson-xp.ddns.mvista.com>	 <47588610.5010804@gmail.com>	 <1196989515.1568.131.camel@jnielson-xp.ddns.mvista.com>	 <4758A216.3030401@gmail.com>	 <1196991637.1568.140.camel@jnielson-xp.ddns.mvista.com>	 <475ADFC5.4030108@gmail.com> <1197138162.1568.172.camel@jnielson-xp.ddns.mvista.com>
In-Reply-To: <1197138162.1568.172.camel@jnielson-xp.ddns.mvista.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
>> Yes, you are right, I hadn't finished looking at all of the up() calls
>> when I came to my conclusion.  I will try to convert a few that are not
>> on your list, but I would like to know how you are generating your
>> patches into those files with the diffstat and recipient list.  Is that
>> a feature of some git command?
> 
> Git may have a similar feature, but I'm using a tool call Quilt. It's
> used for managing a list of patches, and it can automatically add a
> diffstat to the patch header (part of the quilt refresh command). I also
> use it for emailing a list of patches.
> 

Yes, I've used quilt for working with mm patches in the past, but I'm
not too familiar with the mail features.  For example, how do you get
the recipient list and Signed-off-by in the patch file?  Do you just
edit it by hand?  Or is there some guide to quilt I should be reading?
I looked at the guide in /usr/share/doc/quilt/quilt.pdf, but it didn't
have anything about email.  /usr/share/doc/quilt/README.MAIL has the
details of all of the mail options, but doesn't give a nice example of
what to do with the patch file and how to call 'quilt mail'.

-- 
Kevin Winchester
