Return-Path: <linux-kernel-owner+w=401wt.eu-S1762122AbYBRW0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762122AbYBRW0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 17:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbYBRWZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 17:25:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117AbYBRWZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 17:25:54 -0500
Date: Mon, 18 Feb 2008 16:16:04 -0600
From: David Teigland <teigland@redhat.com>
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Joonwoo Park <joonwpark81@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, kurt.hackel@oracle.com
Subject: Re: [PATCH 2/2] [RESENDING] fs/ocfs2: get rid of unnecessary initialization
Message-ID: <20080218221604.GB5438@redhat.com>
References: <12027209122955-git-send-email-joonwpark81@gmail.com> <12027209163465-git-send-email-joonwpark81@gmail.com> <20080218193030.GX22671@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218193030.GX22671@ca-server1.us.oracle.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 11:30:30AM -0800, Mark Fasheh wrote:
> On Mon, Feb 11, 2008 at 06:08:31PM +0900, Joonwoo Park wrote:
> > default_groups was allocated with kcalloc, so initialize to NULL
> > is unnecessary.
> 
> NACK - this isn't a performance critical section of code and that line makes
> the array termination obvious, so I'm inclined to leave it as is.

The same nack for the same patch under fs/dlm.

Dave

