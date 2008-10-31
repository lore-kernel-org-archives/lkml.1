Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbYJaTfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbYJaTfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 15:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbYJaTf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 15:35:26 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38456 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbYJaTfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 15:35:25 -0400
Subject: Re: [PATCH 2/3] integrity: Linux Integrity Module(LIM)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <1225471251.12673.408.camel@nimitz>
References: <cover.1223869200.git.zohar@localhost.localdomain>
	 <7c05f813215804a30d03821fd8e251b250d0e000.1223869200.git.zohar@localhost.localdomain>
	 <1225471251.12673.408.camel@nimitz>
Content-Type: text/plain
Date: Fri, 31 Oct 2008 15:35:22 -0400
Message-Id: <1225481722.21941.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-31 at 09:40 -0700, Dave Hansen wrote: 
> On Mon, 2008-10-13 at 13:17 -0400, Mimi Zohar wrote:
> > Concern was raised on the lkml mailing list, about adding i_integrity
> > to the inode structure.  This patch adds a comment clarifying that
> > i_integrity is only included in the inode if INTEGRITY is configured.
> 
> Mimi, it is nice that you made this a config option.  That definitely
> helps the embedded folks and those compiling their own kernels.  But, it
> doesn't really help those who run distros.
> 
> The distributions basically ship one kernel for everybody, and it has to
> have CONFIG_KITCHEN_SINK=y in order to support everyone's individual
> users.  Although you provided a config option, in practice, this always
> bloats distro kernels which are the vast majority of users.

Thank you for giving a more fuller explanation as to why extending the
inode is such an issue.

> Is this even useful for filesystems like proc or sysfs?  Should we bloat
> those inodes for a feature which might not possibly apply there?

Currently, we're not measuring proc or sysfs files.

Mimi

