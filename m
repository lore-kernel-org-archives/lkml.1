Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbYAQDs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbYAQDs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 22:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYAQDst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 22:48:49 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38154 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbYAQDss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 22:48:48 -0500
Date: Thu, 17 Jan 2008 03:48:44 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Cedric Le Goater <clg@fr.ibm.com>, drepper@redhat.com,
       Serge Hallyn <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Extend sys_clone and sys_unshare system calls API
Message-ID: <20080117034844.GA27894@ZenIV.linux.org.uk>
References: <478DFF8F.9030006@openvz.org> <9803.1200493420@vena.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9803.1200493420@vena.lwn.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 07:23:40AM -0700, Jonathan Corbet wrote:
> Hi, Pavel,
> 
> [Adding Ulrich]
> 
> > I use the last bit in the clone_flags for CLONE_LONGARG. When set it
> > will denote that the child_tidptr is not a pointer to a tid storage,
> > but the pointer to the struct long_clone_struct which currently 
> > looks like this:
> 
> I'm probably just totally off the deep end, but something did occur to
> me: this looks an awful lot like a special version of the sys_indirect()
> idea.  Unless it has been somehow decided that sys_indirect() is the
> wrong idea, might it not be better to look at making that interface
> solve the extended clone() problem as well?

Nah, just put an XML parser into the kernel to have the form match the
contents...

Al "perhaps we should newgroup alt.tasteless.api for all that stuff" Viro
