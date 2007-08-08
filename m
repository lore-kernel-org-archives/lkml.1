Return-Path: <linux-kernel-owner+w=401wt.eu-S1760404AbXHHID7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760404AbXHHID7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 04:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbXHHIDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 04:03:42 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56813 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbXHHIDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 04:03:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, stern@rowland.harvard.edu,
       Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, gregkh@suse.de
Subject: Re: [PATCH 0/25] Sysfs cleanups & tagged directory support
References: <11860582832964-git-send-email-htejun@gmail.com>
	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>
	<20070808093815.0935a18e@gondolin.boeblingen.de.ibm.com>
	<m1bqdifowo.fsf@ebiederm.dsl.xmission.com>
	<20070808095432.4a520735@gondolin.boeblingen.de.ibm.com>
Date: Wed, 08 Aug 2007 01:57:07 -0600
In-Reply-To: <20070808095432.4a520735@gondolin.boeblingen.de.ibm.com>
	(Cornelia Huck's message of "Wed, 8 Aug 2007 09:54:32 +0200")
Message-ID: <m17io6foh8.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck <cornelia.huck@de.ibm.com> writes:

> On Wed, 08 Aug 2007 01:47:51 -0600,
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> Cornelia Huck <cornelia.huck@de.ibm.com> writes:
>> 
>> > My udev failed to create /dev/dasd* so it cannot mount root :( I'm
>> > currently trying to find out what causes this, may take some time...
>> 
>> Oh weird.
>> 
>> No great surprise that something goofed up given how many
>> patches were involved.  Still there shouldn't have been
>> any user visible differences in the patchset.
>> 
>> If you can narrow down which patch caused the problem that would be
>> great.
>
> Got it: It's patch 6, the readdir simplification.
>
> (The udev on that guest is ancient (063)...)

Ok.  That is weird.

Does it depend on the order in which the dentries are returned from
readdir?

Unless I made a really stupid error otherwise the two versions
of readdir should have the same semantics.

Eric
