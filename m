Return-Path: <linux-kernel-owner+w=401wt.eu-S932518AbXAXU33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518AbXAXU33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 15:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932503AbXAXU32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 15:29:28 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50099 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbXAXU31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 15:29:27 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Linux Containers <containers@lists.osdl.org>,
       linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 2/2] Implement shadow directory support for device classes.
References: <m1fya01alj.fsf@ebiederm.dsl.xmission.com>
	<m1bqko1aj4.fsf@ebiederm.dsl.xmission.com>
	<20070124195017.GA27315@suse.de>
Date: Wed, 24 Jan 2007 13:28:22 -0700
In-Reply-To: <20070124195017.GA27315@suse.de> (Greg KH's message of "Wed, 24
	Jan 2007 11:50:17 -0800")
Message-ID: <m1y7nsyxsp.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Wed, Jan 24, 2007 at 12:37:19PM -0700, Eric W. Biederman wrote:
>> 
>> Modify the device class code so that normal manipulations work
>> in the presence of shadow directories.  Some of the shadow directory
>> support still needs to be implemented in the implementation of the
>> class but these modifications are sufficient to make that simple.
>
> This is a nice idea, but I'm working to get rid of 'struct class_device'
> from the tree.  Network devices have already been converted, the patch
> is in the -mm tree, I'm working on some firewire fixes before pushing it
> to Linus.
>
> So, I think you want to do this work for 'struct device' too, as that is
> what will be the real user of this code.

Sure.  That shouldn't be too hard.

Is any of that work in Dave Millers' networking tree?

I'm just trying to figure out where your work is, relative to the rest of
the networking stack.

I have a lot of networking infrastructure I need to touch.

Eric
