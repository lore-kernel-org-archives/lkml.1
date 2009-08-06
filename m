Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbZHFSiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbZHFSiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 14:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbZHFSiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 14:38:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53453 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbZHFSiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 14:38:15 -0400
Subject: Re: security module question
From: Eric Paris <eparis@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: Justin Banks <justinb@bakbone.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <alpine.LRH.2.00.0908051159100.29562@tundra.namei.org>
References: <20090804220632.GG26133@bleen>
	 <alpine.LRH.2.00.0908051159100.29562@tundra.namei.org>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 14:38:08 -0400
Message-Id: <1249583888.20644.37.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-05 at 12:02 +1000, James Morris wrote:
> On Tue, 4 Aug 2009, Justin Banks wrote:
> 
> > Hello - I'm trying to implement a security module that will allow or
> > disallow writes on files by byte ranges. Is there a way to use
> > inode_permission() to do this, or is there an alternative route I should
> > take? It doesn't look like inode_permission() will give me the data I
> > need (offset + length of write).

There is nothing that can do that.  Neither fanotify nor the LSM.
Biggest problem is mmap.....

I think there was past kernel module which did this, but I don't
remember what they were called.  Nothing which tracks this and could be
used was ever reasonable for the mainline kernel.

-Eric

