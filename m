Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbZERNZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbZERNZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 09:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbZERNZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 09:25:24 -0400
Received: from THUNK.ORG ([69.25.196.29]:35948 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbZERNZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 09:25:23 -0400
Date: Mon, 18 May 2009 09:25:17 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David Watson <kernel-nospam@dbwatson.ukfsn.org>
Subject: Re: [Bug #13232] ext3/4 with synchronous writes gets wedged by
	Postfix
Message-ID: <20090518132517.GL32019@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	David Watson <kernel-nospam@dbwatson.ukfsn.org>
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera> <pQ9WADCjgyE.A.yJG.DA0DKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pQ9WADCjgyE.A.yJG.DA0DKB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 16, 2009 at 10:06:04PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13232
> Subject		: ext3/4 with synchronous writes gets wedged by Postfix
> Submitter	: David Watson <kernel-nospam@dbwatson.ukfsn.org>
> Date		: 2009-05-03 19:46 (14 days old)

This turned out to be caused by change in the VFS, as documented in
the bug report.  Al Viro has a patch, which I've reviewed.

David, would you be able to try testing Al's proposed patch, since you
have an easy reproduction case?  Thanks,

						- Ted

