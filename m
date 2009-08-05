Return-Path: <linux-kernel-owner+w=401wt.eu-S933258AbZHECDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258AbZHECDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 22:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933168AbZHECDC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 22:03:02 -0400
Received: from tundra.namei.org ([65.99.196.166]:41874 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933159AbZHECDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 22:03:01 -0400
Date: Wed, 5 Aug 2009 12:02:39 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Justin Banks <justinb@bakbone.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>
Subject: Re: security module question
In-Reply-To: <20090804220632.GG26133@bleen>
Message-ID: <alpine.LRH.2.00.0908051159100.29562@tundra.namei.org>
References: <20090804220632.GG26133@bleen>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Aug 2009, Justin Banks wrote:

> Hello - I'm trying to implement a security module that will allow or
> disallow writes on files by byte ranges. Is there a way to use
> inode_permission() to do this, or is there an alternative route I should
> take? It doesn't look like inode_permission() will give me the data I
> need (offset + length of write).

This doesn't seem to fit with the LSM model, where access is mediated at 
object-level granularity.  i.e. can user A read file B ?

> Also, is there a security module that will examine data being written
> for certain patterns or content?

The fanotify / TALPA file access scanning work being done by Eric Paris 
might be more appropriate.

See http://lwn.net/Articles/339399/

> Please CC: me on responses. I used to be subscribed, but the traffic was
> just too much.

You probably want the LSM mailing list (cc'd).


-- 
James Morris
<jmorris@namei.org>
