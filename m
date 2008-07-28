Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbYG1WCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbYG1WCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbYG1WCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:02:37 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:14847 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbYG1WCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:02:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gA9kVU9IWPM1EMGNO2s7xmv6Y05NPK6orV+0RHpFLc+0pHj5x8VzLgZzaeeBSszNo1
         pM53cKw19sOB3nyBwvDEQG7XfwWxzmsi1nph66RVUhZXwL4n+v6uPmzxJNweIm2slXJz
         vJ+se37sfDFYqtmyKZVdlPsyk9Vh5m6Hihyhk=
Subject: Re: [PATCH] FILESYSTEMS: Make "advanced partitions" immediately
 unselectable.
From: Calvin Walton <calvin.walton@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <alpine.LFD.1.10.0807281437070.10586@localhost.localdomain>
References: <alpine.LFD.1.10.0807241135540.5289@localhost.localdomain>
	 <20080726094718.b617c1e7.randy.dunlap@oracle.com>
	 <alpine.LFD.1.10.0807261750340.3493@localhost.localdomain>
	 <1217214689.22927.3.camel@zem.phub.net.cable.rogers.com>
	 <alpine.LFD.1.10.0807280531210.3402@localhost.localdomain>
	 <20080728103731.7bafd577.randy.dunlap@oracle.com>
	 <alpine.LFD.1.10.0807281437070.10586@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 18:02:20 -0400
Message-Id: <1217282540.22927.13.camel@zem.phub.net.cable.rogers.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 14:42 -0400, Robert P. J. Day wrote:
> On Mon, 28 Jul 2008, Randy Dunlap wrote:
> it strikes me that, at least on x86, MSDOS partition support is so
> fundamental that it should take work for someone to turn it *off*.
> perhaps simply have it on by default, and force someone to go under
> "Configure standard kernel features (for small systems)"
> (CONFIG_EMBEDDED) to make it go away?
> 
>   seriously, how often is someone going to build a kernel for x86 and
> not need MSDOS partition support?  just curious.
> 
> rday

Naturally, on an architecture other than x86 (e.g. sparc) you'll want to
ensure that the platform's native partitioning format (for sparc,
SUN_PARTITION) is similarly on by default, and difficult to unselect. 

In this case, you could get by perfectly without msdos partitions
enabled (although the default is still to enable them), unless you want
to read a usb key or something.

This was the point of the original menu, I think - it allowed each
partition type to have a default based on arch, but to hide away the
mess of other types unless you feel like overriding it.

You'll want to make sure in your patch that arches other than x86 don't
lose their own native partitioning types :)

-- 
Calvin Walton <calvin.walton@gmail.com>

