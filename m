Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbZGOOjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbZGOOjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 10:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754807AbZGOOje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 10:39:34 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:63100 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbZGOOjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 10:39:33 -0400
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: jmorris@namei.org
Cc: sds@tycho.nsa.gov, gregkh@susa.de, casey@schaufler-ca.com,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
In-Reply-To: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 15 Jul 2009 10:28:55 -0400
Message-Id: <1247668135.4398.387.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some odd reason guilt and git-send-email doesn't allow me to specify
a summary email for when there is a single patch in the patch set. So I
will put the comments here.

This is revision two of the sysfs security xattr support patch. It has
taken Eric's suggestion and adds a new structure which holds all the
optional sysfs_dirent inode metadata. This is allocated when either the
security label or some other inode property is changed. I still believe
that a secid is the way to go here and that the hooks proposed for sysfs
are usable by other psudo file systems and where to store the secid will
have to be assessed on a case by case basis.

Dave

