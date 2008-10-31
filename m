Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577AbYJaVDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbYJaVDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 17:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYJaVCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 17:02:53 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39673 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbYJaVCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 17:02:50 -0400
Subject: Re: [PATCH 2/3] integrity: Linux Integrity Module(LIM)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <1225481722.21941.42.camel@localhost.localdomain>
References: <cover.1223869200.git.zohar@localhost.localdomain>
	 <7c05f813215804a30d03821fd8e251b250d0e000.1223869200.git.zohar@localhost.localdomain>
	 <1225471251.12673.408.camel@nimitz>
	 <1225481722.21941.42.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 31 Oct 2008 14:02:47 -0700
Message-Id: <1225486967.12673.418.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-31 at 15:35 -0400, Mimi Zohar wrote:
> > Is this even useful for filesystems like proc or sysfs?  Should we bloat
> > those inodes for a feature which might not possibly apply there?
> 
> Currently, we're not measuring proc or sysfs files.

So, one of the points is that this "bloats" 'struct inode' for at least
these two filesystems.  It has no use there, so it does not help much to
stick it in a common structure that those use.

-- Dave

