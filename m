Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbYAPOXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbYAPOXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 09:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYAPOXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 09:23:41 -0500
Received: from vena.lwn.net ([206.168.112.25]:41616 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbYAPOXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 09:23:40 -0500
To: Pavel Emelyanov <xemul@openvz.org>
CC: Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Cedric Le Goater <clg@fr.ibm.com>, drepper@redhat.com,
       Serge Hallyn <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Extend sys_clone and sys_unshare system calls API 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Wed, 16 Jan 2008 15:58:55 +0300."
             <478DFF8F.9030006@openvz.org> 
Date: Wed, 16 Jan 2008 07:23:40 -0700
Message-ID: <9803.1200493420@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Pavel,

[Adding Ulrich]

> I use the last bit in the clone_flags for CLONE_LONGARG. When set it
> will denote that the child_tidptr is not a pointer to a tid storage,
> but the pointer to the struct long_clone_struct which currently 
> looks like this:

I'm probably just totally off the deep end, but something did occur to
me: this looks an awful lot like a special version of the sys_indirect()
idea.  Unless it has been somehow decided that sys_indirect() is the
wrong idea, might it not be better to look at making that interface
solve the extended clone() problem as well?

jon
