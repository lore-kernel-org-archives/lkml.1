Return-Path: <linux-kernel-owner+w=401wt.eu-S1763473AbYFED2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763473AbYFED2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 23:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbYFED2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 23:28:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:53174 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbYFED2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 23:28:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WnY24i08BvpdWYKLzJtZJkdlU/5XVsGhjeoFV24kflUwyQzYims06b3/Do1VAsMH6V
         zk2wWtVa02cgmHa/YJZ2ADwAYWSGaIx3qiKufCfu9FlBZ0JXzqi/nyT/+WVxmudDyyLg
         urp77dllNdvptCN1BzEGtjvDZxdIDxfr7QhIw=
Message-ID: <170fa0d20806042028r738795d2h6b6452ecb3e0f4b7@mail.gmail.com>
Date: Wed, 4 Jun 2008 23:28:09 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>,
       "Andrew Morton" <akpm@linux-foundation.org>, "Jan Kara" <jack@suse.cz>,
       "Hidehiro Kawai" <hidehiro.kawai.ez@hitachi.com>, sct@redhat.com,
       adilger@sun.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, jbacik@redhat.com, cmm@us.ibm.com,
       yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
Subject: Re: [PATCH 1/5] jbd: strictly check for write errors on data buffers
In-Reply-To: <20080604212202.GA8727@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4843CE15.6080506@hitachi.com> <4843CEED.9080002@hitachi.com>
	 <20080603153050.fb99ac8a.akpm@linux-foundation.org>
	 <20080604101925.GB16572@duck.suse.cz>
	 <20080604111911.c1fe09c6.akpm@linux-foundation.org>
	 <20080604212202.GA8727@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2008 at 5:22 PM, Theodore Tso <tytso@mit.edu> wrote:

> That being said, ext3 can be tuned (and it is the default today,
> although I should probably change the default to be remount-ro), so
> that its behaviour on write errors is, "don't worry, be happy", and
> just leave the filesystem mounted read/write.  That's actually quite
> dangerous for a critical production server, however.....

I'm not completely sure which "it" you mean in "it is the default
today" (seems like you mean errors=continue) but isn't remount-ro
already the ext3 default?

see commit: 1eca93f9cafdec4a332ace9b0fc0d3886d430c28
