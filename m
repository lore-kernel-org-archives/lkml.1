Return-Path: <linux-kernel-owner+w=401wt.eu-S1030391AbXCVKNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030391AbXCVKNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 06:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030401AbXCVKNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 06:13:32 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36930 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030391AbXCVKNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 06:13:31 -0400
Date: Thu, 22 Mar 2007 15:50:32 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: menage@google.com
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru,
       rohitseth@google.com, pj@sgi.com, ebiederm@xmission.com,
       mbligh@google.com, winget@google.com, containers@lists.osdl.org,
       serue@us.ibm.com, devel@openvz.org, Maneesh <maneesh@in.ibm.com>
Subject: Re: [ckrm-tech] [PATCH 1/7] containers (V7): Generic container system abstracted from cpusets code
Message-ID: <20070322102032.GA21843@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.130746000@menage.corp.google.com> <20070322095651.GA17796@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322095651.GA17796@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 03:26:51PM +0530, Srivatsa Vaddagiri wrote:
> On Mon, Feb 12, 2007 at 12:15:22AM -0800, menage@google.com wrote:
> > +static void remove_dir(struct dentry *d)
> > +{
> > +	struct dentry *parent = dget(d->d_parent);
> 
> Don't we need to lock parent inode's mutex here? sysfs seems to take
> that lock.

Never mind. Maneesh pointed me to do_rmdir() in VFS which takes that
mutex as well.

-- 
Regards,
vatsa
