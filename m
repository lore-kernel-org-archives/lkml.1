Return-Path: <linux-kernel-owner+w=401wt.eu-S1760515AbYJMXcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760515AbYJMXcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 19:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757119AbYJMXc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 19:32:29 -0400
Received: from tundra.namei.org ([65.99.196.166]:47881 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932AbYJMXc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 19:32:28 -0400
Date: Tue, 14 Oct 2008 10:31:50 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
cc: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, labeled-nfs@linux-nfs.org
Subject: Re: [RFC v3] Security Label Support for NFSv4
In-Reply-To: <1222707986-26606-1-git-send-email-dpquigl@tycho.nsa.gov>
Message-ID: <alpine.LRH.1.10.0810141014580.26030@tundra.namei.org>
References: <1222707986-26606-1-git-send-email-dpquigl@tycho.nsa.gov>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008, David P. Quigley wrote:

> 	* New security flavor (auth_seclabel) to transport process label to
> 	  server. This is a derivative of auth_unix so it does not support
> 	  kerberos which has its own issues that need to be dealt with.

This is a problem, as discussed last year:

http://linux-nfs.org/pipermail/labeled-nfs/2007-November/000110.html

We can't require the use of a new auth flavor which is incompatible with 
auth_gss.


- James
-- 
James Morris
<jmorris@namei.org>
