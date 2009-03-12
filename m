Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbZCLUEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbZCLUEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 16:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZCLUEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 16:04:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752269AbZCLUEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 16:04:40 -0400
Date: Thu, 12 Mar 2009 13:02:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: phillips@phunq.net, tux3@tux3.org, linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Message-Id: <20090312130222.b149cf36.akpm@linux-foundation.org>
In-Reply-To: <87vdqeogtm.fsf@devron.myhome.or.jp>
References: <200903110925.37614.phillips@phunq.net>
	<20090311114211.89eed5b8.akpm@linux-foundation.org>
	<87vdqeogtm.fsf@devron.myhome.or.jp>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Mar 2009 01:18:29 +0900
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > - When 'bh' is known to be non-NULL, use put_bh() rather than brelse().
> 
> It sounds strange. Almost all bh is non-NULL. This means we are going to
> replace almost all brelse() by put_bh()?
> 

Well..  you can make up your own mind about this.  If you see benefit
in the NULL-checking and extra debugging which brelse() provides then
continue to use brelse().

