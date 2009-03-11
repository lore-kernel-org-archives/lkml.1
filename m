Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbZCKDOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbZCKDOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 23:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbZCKDOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 23:14:35 -0400
Received: from a.jim.sh ([75.150.123.25]:54412 "EHLO psychosis.jim.sh"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbZCKDOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 23:14:34 -0400
X-Greylist: delayed 651 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Mar 2009 23:14:34 EDT
Date: Tue, 10 Mar 2009 23:03:40 -0400
From: Jim Paris <jim@jtan.com>
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Off-by-one in both LIBATA and IDE drivers
Message-ID: <20090311030340.GA617@psychosis.jim.sh>
References: <20090311015039.42922.qmail@web4115.mail.ogk.yahoo.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311015039.42922.qmail@web4115.mail.ogk.yahoo.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Norman Diamond wrote:
> It looks like both LIBATA and the old IDE drivers have an
> off-by-one error in deciding whether to use READ SECTOR(S)
> instead of READ SECTOR(S) EXT.

Hi,

This was fixed here:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=97b697a11b07e2ebfa69c488132596cc5eb24119

-jim
