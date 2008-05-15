Return-Path: <linux-kernel-owner+w=401wt.eu-S1763267AbYEOSZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763267AbYEOSZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbYEOSY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:24:56 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:45307 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbYEOSYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:24:55 -0400
Date: Thu, 15 May 2008 22:23:43 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       mpm@selenic.com
Subject: Re: [patch 18/21] Filesystem: Socket inode defragmentation
Message-ID: <20080515182343.GA30899@2ka.mipt.ru>
References: <20080510030831.796641881@sgi.com> <20080510030918.882272887@sgi.com> <20080513132810.GA7152@2ka.mipt.ru> <Pine.LNX.4.64.0805151039060.18708@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805151039060.18708@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 10:40:11AM -0700, Christoph Lameter (clameter@sgi.com) wrote:
> All inodes are inactivated and put on a lru before they are freed. Those 

I have to check my memory, but iput()->destroy_inode() highlights first for sockets...

-- 
	Evgeniy Polyakov
