Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbZGURLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbZGURLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 13:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbZGURLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 13:11:00 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:57877 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbZGURK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 13:10:59 -0400
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: jmorris@namei.org
Cc: sds@tycho.nsa.gov, Greg KH <greg@kroah.com>, casey@schaufler-ca.com,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
In-Reply-To: <1248194067.10726.22.camel@localhost>
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <1248194067.10726.22.camel@localhost>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 21 Jul 2009 13:01:40 -0400
Message-Id: <1248195700.10726.28.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 12:34 -0400, David P. Quigley wrote:
> I've found a problem with the patch that I want to fix. So I will be
> posting another version of it soon.
> 
> Dave
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Looking more closely at the problem I was mistaken. I was concerned with
the dereferenceing of the dentry in the first line of the getxattr
function but it seems that a precondition for us getting that far is
that we will always have a valid dentry at that point. I'd appreciate it
if the people whose code the patch touches can review the patch again
and either NAK with more comments or sign off on it.

Dave

