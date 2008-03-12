Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbYCLAJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbYCLAJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 20:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbYCLAJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 20:09:36 -0400
Received: from mail.lang.hm ([64.81.33.126]:42468 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbYCLAJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 20:09:35 -0400
Date: Tue, 11 Mar 2008 17:09:32 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Nigel Cunningham <ncunningham@crca.org.au>
cc: Vivek Goyal <vgoyal@redhat.com>, "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm] kexec jump -v9
In-Reply-To: <1205272758.7990.37.camel@nigel-laptop>
Message-ID: <alpine.DEB.1.00.0803111708270.32330@asgard.lang.hm>
References: <1204773188.4707.109.camel@caritas-dev.intel.com>  <20080311211004.GA30164@redhat.com> <1205272758.7990.37.camel@nigel-laptop>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Nigel Cunningham wrote:

> 3. Usability.
>
> Right now, kexec based hibernation looks quite complicated to configure,
> and the user is apparently going to have to remember to boot a different
> kernel or at least a different bootloader entry in order to resume. Not
> a plus. It would be good if you could find a way to use one bootloader
> entry, resuming if there's an image, booting normally if there's not.

I don't see any reason why this couldn't be done with an initrd to decide 
if you are doing a normal boot or a restore.

David Lang
