Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbYB1OX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbYB1OX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 09:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbYB1OXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 09:23:12 -0500
Received: from gv-out-0910.google.com ([216.239.58.191]:20605 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbYB1OWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 09:22:55 -0500
Message-ID: <7e0fb38c0802280622o75a474deg38157ff6aace16b@mail.gmail.com>
Date: Thu, 28 Feb 2008 09:22:50 -0500
From: "Eric Paris" <eparis@parisplace.org>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Subject: Re: [PATCH 07/11] NFS/SELinux: Add security_label text mount option to nfs and add handling code to the security server.
Cc: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <1204150294-4678-8-git-send-email-dpquigl@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <1204150294-4678-8-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/27/08, David P. Quigley <dpquigl@tycho.nsa.gov> wrote:
> The new method for pulling argument for NFS from mount is through a text
>  parsing system. This patch adds two new entries to the argument parsing code
>  "securlty_label" and "nosecurity_label". Even though we use text across the
>  user/kernel boundary internally we still pack a binary structure for mount info
>  to be passed around. We add a flag for use in the nfs{4,}_mount_data struct to
>  indicate that are using security labels. Finally we add the SELinux support to
>  mark the labeling method as native.

I've got patches that noone has seen because I haven't posted them yet
(my test box crashed yesterday and I didn't have time to make sure it
wasn't my new patches) you are going to need to rebase this against.
Adding more nfs'isms to selinux code isn't a good thing in the long
run.  But, does this even really work?  I thought both NFS and NFSv4
were actually passing around struct nfs_parsed_mount_data now rather
than just nfs_mount_data.  Maybe not, but this patch, although fine
for testing isn't fine to go in.  I'll get you and the list my new
option interfaces on monday so we can get NFS out of all of the LSMs
and get SELinux out of NFS.

-Eric
