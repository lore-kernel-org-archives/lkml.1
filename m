Return-Path: <linux-kernel-owner+w=401wt.eu-S1751174AbZGIWqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174AbZGIWqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 18:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750717AbZGIWqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 18:46:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53634 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbZGIWqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 18:46:13 -0400
Message-ID: <4A567310.5@redhat.com>
Date: Thu, 09 Jul 2009 18:45:36 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, linux-kernel@vger.kernel.org,
       npiggin@suse.de, akpm@osdl.org, jeremy@goop.org,
       xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
       alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org, kurt.hackel@oracle.com,
       Rusty Russell <rusty@rustcorp.com.au>, dave.mccracken@oracle.com,
       Marcelo Tosatti <mtosatti@redhat.com>, sunil.mushran@oracle.com,
       Avi Kivity <avi@redhat.com>, Schwidefsky <schwidefsky@de.ibm.com>,
       chris.mason@oracle.com, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 0/4] (Take 2): transcendent memory ("tmem") for Linux
References: <7cb22078-f200-45e3-a265-10cce2ae8224@default>
In-Reply-To: <7cb22078-f200-45e3-a265-10cce2ae8224@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Magenheimer wrote:

> But this means that either the content of that page must have been
> preserved somewhere or the discard fault handler has sufficient
> information to go back and get the content from the source (e.g.
> the filesystem).  Or am I misunderstanding?

The latter.  Only pages which can be fetched from
source again are marked as volatile.

> But IMHO this is a corollary of the fundamental difference.  CMM2's
> is more the "VMware" approach which is that OS's should never have
> to be modified to run in a virtual environment.

Actually, the CMM2 mechanism is quite invasive in
the guest operating system's kernel.

> ( I don't see why CMM2 provides more flexibility.

I don't think anyone is arguing that.  One thing
that people have argued is that CMM2 can be more
efficient, and easier to get the policy right in
the face of multiple guest operating systems.

-- 
All rights reversed.
