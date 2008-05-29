Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbYE2Vur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbYE2Vur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbYE2Vuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:50:39 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:43784 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbYE2Vui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:50:38 -0400
Subject: Re: [RFC][Patch 5/5]integrity: IMA as an integrity service provider
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com,
       Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>
In-Reply-To: <20080528203013.5a927d30.akpm@linux-foundation.org>
References: <1211555145.16195.18.camel@new-host>
	 <20080528012242.a0e98d87.akpm@linux-foundation.org>
	 <1212031046.4747.57.camel@new-host.home>
	 <20080528203013.5a927d30.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 29 May 2008 17:50:34 -0400
Message-Id: <1212097834.15923.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-28 at 20:30 -0700, Andrew Morton wrote:

> > ...
> >
> > > - All the games with mtimes should be described in the changelog too.
> > 
> > Ok. The timespec_recent and mtime issues are part of the same problem
> > of detecting when a file has been modified.
> 
> Can't use inode.i_version?

i_version is now working on my system.  It looks good. Is
there anything that I need to be concerned about, such as
limited filesystem support or the i_version is not updated 
by file_close for mmaped files?

Thanks!

Mimi

