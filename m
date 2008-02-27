Return-Path: <linux-kernel-owner+w=401wt.eu-S1761239AbYB0V13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761239AbYB0V13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbYB0V1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:27:19 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:13396 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbYB0V1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:27:18 -0500
Date: Wed, 27 Feb 2008 13:26:45 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Julia Lawall <julia@diku.dk>
Cc: kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 8/9] fs/ocfs2/aops.c: Correct use of ! and &
Message-ID: <20080227212645.GP27865@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <Pine.LNX.4.64.0802262145321.18200@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802262145321.18200@ask.diku.dk>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 09:45:56PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
> involved converting !x & y to !(x & y).  The code below shows the same
> pattern, and thus should perhaps be fixed in the same way.
> 
> This is not tested and clearly changes the semantics, so it is only
> something to consider.

That looks fine - it's in Ocfs2.git now, thanks.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
