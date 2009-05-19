Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbZESRRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbZESRRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 13:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZESRRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 13:17:11 -0400
Received: from mail.ukfsn.org ([77.75.108.10]:33232 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbZESRRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 13:17:11 -0400
Date: Tue, 19 May 2009 18:17:13 +0100
From: David Watson <kernel-nospam@dbwatson.ukfsn.org>
To: Theodore Tso <tytso@mit.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13232] ext3/4 with synchronous writes gets wedged by
	Postfix
Message-ID: <20090519171713.GA3354@dbwatson.ukfsn.org>
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera> <pQ9WADCjgyE.A.yJG.DA0DKB@chimera> <20090518132517.GL32019@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518132517.GL32019@mit.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 18 May 2009, Theodore Tso wrote:
> On Sat, May 16, 2009 at 10:06:04PM +0200, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13232
> > Subject		: ext3/4 with synchronous writes gets wedged by Postfix
> > Submitter	: David Watson <kernel-nospam@dbwatson.ukfsn.org>
> > Date		: 2009-05-03 19:46 (14 days old)
> 
> This turned out to be caused by change in the VFS, as documented in
> the bug report.  Al Viro has a patch, which I've reviewed.
> 
> David, would you be able to try testing Al's proposed patch, since you
> have an easy reproduction case?  Thanks,

Yes, it fixes the problem for me on 2.6.30-rc6-git3 and 2.6.29.4-rc1.
