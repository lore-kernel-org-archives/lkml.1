Return-Path: <linux-kernel-owner+w=401wt.eu-S965221AbXAYCnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965221AbXAYCnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 21:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965220AbXAYCnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 21:43:45 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43053 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965171AbXAYCnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 21:43:43 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Linux Containers <containers@lists.osdl.org>,
       linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 2/2] Implement shadow directory support for device classes.
References: <m1fya01alj.fsf@ebiederm.dsl.xmission.com>
	<m1bqko1aj4.fsf@ebiederm.dsl.xmission.com>
	<20070124195017.GA27315@suse.de>
	<m1y7nsyxsp.fsf@ebiederm.dsl.xmission.com>
	<20070124212824.GA29981@suse.de>
Date: Wed, 24 Jan 2007 19:43:09 -0700
In-Reply-To: <20070124212824.GA29981@suse.de> (Greg KH's message of "Wed, 24
	Jan 2007 13:28:24 -0800")
Message-ID: <m1mz47zv0i.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> Or you can try it with any of the subsystems that have already been
> converted over to use the struct device code, like misc, mem, and many
> others.  Just look for the symlinks in /sys/class/CLASS_NAME/ instead of
> real subdirectories.
>
> So I'd really prefer to not apply this patch, and just do this kind of
> work for 'struct device' instead.

I don't want to get stuck waiting for cleanups so I will keep this one,
even if you don't apply it :)  

But I will go figure out the equivalent version for struct device, as
it doesn't look like you are that far off from merging that version. :)

That way my code will work whichever code base I have to merge against.

Eric
