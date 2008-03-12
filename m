Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbYCLPCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbYCLPCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 11:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbYCLPBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 11:01:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47917 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751806AbYCLPBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 11:01:50 -0400
Date: Wed, 12 Mar 2008 11:01:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Huang, Ying" <ying.huang@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <nigel@nigel.suspend2.net>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-pm@lists.linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
In-Reply-To: <1205286937.29875.9.camel@caritas-dev.intel.com>
Message-ID: <Pine.LNX.4.44L0.0803121055510.4595-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Huang, Ying wrote:

> I think "kexec based hibernation" is the only currently available
> possible method to write out image without freezer (after driver works
> are done). If other process is running, how to prevent them from writing
> to disk without freezing them in current implementation?

This is a very good question.

It's a matter of managing the block layer's request queues.  Somehow 
the existing I/O requests must remain blocked while the requests needed 
for writing the image must be allowed to proceed.

I don't know what would be needed to make this work, but it ought to be 
possible somehow...

Alan Stern

