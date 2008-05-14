Return-Path: <linux-kernel-owner+w=401wt.eu-S1762874AbYENQEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762874AbYENQEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 12:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbYENQEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 12:04:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761579AbYENQEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 12:04:11 -0400
Date: Wed, 14 May 2008 12:03:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm] kexec jump -v9
Message-ID: <20080514160329.GF30469@redhat.com>
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204773188.4707.109.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 11:13:08AM +0800, Huang, Ying wrote:
> This is a minimal patch with only the essential features. All
> additional features are split out and can be discussed later. I think
> it may be easier to get consensus on this minimal patch.
> 

Hi Huang,

Ok, after a long time, I am back to testing and reviewing this patch.


[..]
> 7. Boot kernel compiled in step 1 (kernel C). Use the rootfs.gz as
>    root file system.
> 
> 8. In kernel C, load the memory image of kernel A as follow:
> 
>    /sbin/kexec -l --args-none --entry=`cat kexec_jump_back_entry` dump.elf
> 

How do I got back to original kernel without loading dump.elf. I mean,
original kernel is already in memory and I don't have to first save
it to disk and then reload back. Is there a way to do it? If not, then
we need to modify kexec-tools to support that.

Something like

kexec --entry=<entry point>, should tell kexec that kernel is already
loaded. Just do the bit to set the entry point properly.

Thanks
Vivek
