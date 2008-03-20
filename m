Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbYCTS3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbYCTS3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 14:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbYCTS3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 14:29:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43104 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbYCTS3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 14:29:14 -0400
Date: Thu, 20 Mar 2008 18:29:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-netdev <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH] kernel: add byteorder macros with alignment fixups
Message-ID: <20080320182911.GQ10722@ZenIV.linux.org.uk>
References: <1206034454.17059.4.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206034454.17059.4.camel@brick>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 10:34:14AM -0700, Harvey Harrison wrote:
> A common pattern in the kernel (especially networking) is:
> 
> le32_to_cpu(get_unaligned((__le32 *)x));
> 
> Repeat for various combinations of le/be and 64/32/16 bit.  Add
> a variant that operates on possibly unaligned pointers to
> byteorder/generic.h

... and asm/unaligned.h has just acquired fuckloads of places including
it indirectly.  Not Nice(tm).
