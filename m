Return-Path: <linux-kernel-owner+w=401wt.eu-S1760454AbYEMNgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760454AbYEMNgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 09:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbYEMNgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 09:36:05 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:38402 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729AbYEMNgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 09:36:04 -0400
Date: Tue, 13 May 2008 17:28:12 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       mpm@selenic.com
Subject: Re: [patch 18/21] Filesystem: Socket inode defragmentation
Message-ID: <20080513132810.GA7152@2ka.mipt.ru>
References: <20080510030831.796641881@sgi.com> <20080510030918.882272887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080510030918.882272887@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph.

On Fri, May 09, 2008 at 08:08:49PM -0700, Christoph Lameter (clameter@sgi.com) wrote:
> Support inode defragmentation for sockets

Out of curiosity, how can you drop socket inode, since it is always
attached to socket which is removed automatically when connection is
closed. Any force of dropping socket inode can only result in connection
drop, i.e. there are no inodes, which are placed in cache and are not
yet freed, if there are no attached sockets.

So question is how does it work for sockets?

-- 
	Evgeniy Polyakov
