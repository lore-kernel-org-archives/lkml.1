Return-Path: <linux-kernel-owner+w=401wt.eu-S1751422AbZGXIN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbZGXIN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 04:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbZGXIN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 04:13:26 -0400
Received: from tundra.namei.org ([65.99.196.166]:58883 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbZGXINZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 04:13:25 -0400
Date: Fri, 24 Jul 2009 18:13:21 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
cc: sds@tycho.nsa.gov, Greg KH <greg@kroah.com>, casey@schaufler-ca.com,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
In-Reply-To: <1248195700.10726.28.camel@localhost>
Message-ID: <alpine.LRH.2.00.0907241810490.32272@tundra.namei.org>
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>  <1248194067.10726.22.camel@localhost> <1248195700.10726.28.camel@localhost>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009, David P. Quigley wrote:

> Looking more closely at the problem I was mistaken. I was concerned with
> the dereferenceing of the dentry in the first line of the getxattr
> function but it seems that a precondition for us getting that far is
> that we will always have a valid dentry at that point. I'd appreciate it
> if the people whose code the patch touches can review the patch again
> and either NAK with more comments or sign off on it.

Please repost them with a version number so we know exactly which patches 
we're looking at.


-- 
James Morris
<jmorris@namei.org>
