Return-Path: <linux-kernel-owner+w=401wt.eu-S1752521AbZGXOnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbZGXOnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 10:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbZGXOnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 10:43:08 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:54769 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbZGXOnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 10:43:07 -0400
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Cc: sds@tycho.nsa.gov, Greg KH <greg@kroah.com>, casey@schaufler-ca.com,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
In-Reply-To: <alpine.LRH.2.00.0907241810490.32272@tundra.namei.org>
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <1248194067.10726.22.camel@localhost> <1248195700.10726.28.camel@localhost>
	 <alpine.LRH.2.00.0907241810490.32272@tundra.namei.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 24 Jul 2009 10:34:01 -0400
Message-Id: <1248446041.2421.74.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-24 at 18:13 +1000, James Morris wrote:
> On Tue, 21 Jul 2009, David P. Quigley wrote:
> 
> > Looking more closely at the problem I was mistaken. I was concerned with
> > the dereferenceing of the dentry in the first line of the getxattr
> > function but it seems that a precondition for us getting that far is
> > that we will always have a valid dentry at that point. I'd appreciate it
> > if the people whose code the patch touches can review the patch again
> > and either NAK with more comments or sign off on it.
> 
> Please repost them with a version number so we know exactly which patches 
> we're looking at.
> 
> 

Casey is taking a shot at implementing generic xattr support for in
memory file systems.I told him I'd wait to see the initial cut of his
patch before going further with this.

Dave

