Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbYBRTbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbYBRTbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 14:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbYBRTbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 14:31:39 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:30659 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbYBRTbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 14:31:39 -0500
Date: Mon, 18 Feb 2008 11:30:30 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Joonwoo Park <joonwpark81@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       kurt.hackel@oracle.com
Subject: Re: [PATCH 2/2] [RESENDING] fs/ocfs2: get rid of unnecessary
	initialization
Message-ID: <20080218193030.GX22671@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <12027209122955-git-send-email-joonwpark81@gmail.com> <12027209163465-git-send-email-joonwpark81@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12027209163465-git-send-email-joonwpark81@gmail.com>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 06:08:31PM +0900, Joonwoo Park wrote:
> default_groups was allocated with kcalloc, so initialize to NULL
> is unnecessary.

NACK - this isn't a performance critical section of code and that line makes
the array termination obvious, so I'm inclined to leave it as is.

Thanks,
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
