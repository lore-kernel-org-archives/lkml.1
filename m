Return-Path: <linux-kernel-owner+w=401wt.eu-S1755729AbYGUUhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbYGUUhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbYGUUg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:36:59 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:25620 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbYGUUg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:36:58 -0400
Date: Mon, 21 Jul 2008 13:36:08 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Julia Lawall <julia@diku.dk>
Cc: mfasheh@suse.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/7] fs/ocfs2/file.c: Release mutex in error handling
	code
Message-ID: <20080721203608.GB31671@ca-server1.us.oracle.com>
Mail-Followup-To: Julia Lawall <julia@diku.dk>, mfasheh@suse.com,
	ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0807210958570.24625@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807210958570.24625@ask.diku.dk>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 09:59:15AM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The mutex is released on a successful return, so it would seem that it
> should be released on an error return as well.

	This patch looks right to me.  Mark?

Joel


-- 

"If you are ever in doubt as to whether or not to kiss a pretty girl, 
 give her the benefit of the doubt"
                                        -Thomas Carlyle

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
