Return-Path: <linux-kernel-owner+w=401wt.eu-S965724AbXBHXFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965724AbXBHXFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 18:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933366AbXBHXE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 18:04:59 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:46732 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933346AbXBHXE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 18:04:58 -0500
Date: Thu, 8 Feb 2007 15:04:33 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] fs: add an iovec iterator
Message-ID: <20070208230433.GW14799@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070208105437.26443.35653.sendpatchset@linux.site> <20070208105446.26443.35864.sendpatchset@linux.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070208105446.26443.35864.sendpatchset@linux.site>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Thu, Feb 08, 2007 at 02:07:24PM +0100, Nick Piggin wrote:
> Add an iterator data structure to operate over an iovec. Add usercopy
> operators needed by generic_file_buffered_write, and convert that function
> over.

I really like this iterator structure - it brings together some fields that
seem to get passed around seperately, even though they're linked.

Also IMHO, it makes things in filemap.c easer to read...
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
