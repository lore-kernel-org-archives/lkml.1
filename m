Return-Path: <linux-kernel-owner+w=401wt.eu-S1760318AbZE0FvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318AbZE0FvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 01:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758991AbZE0FvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 01:51:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:45259 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759255AbZE0FvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 01:51:06 -0400
Subject: Re: [RFC PATCH]debugfs:Fix terminology inconsistency of dir name
 to mount debugfs filesystem.
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: GeunSik Lim <leemgs1@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org,
       balagi@justmail.de, bgamari@gmail.com, Ingo Molnar <mingo@elte.hu>,
       inaky.perez-gonzalez@intel.com
In-Reply-To: <alpine.DEB.2.00.0905262231210.27902@gandalf.stny.rr.com>
References: <1243315163.14685.17.camel@centos51>
	 <alpine.DEB.2.00.0905261642130.26705@gandalf.stny.rr.com>
	 <20090526205414.GA26016@kroah.com>
	 <alpine.DEB.2.00.0905261711310.26705@gandalf.stny.rr.com>
	 <49b7c2350905261924h34e5f019g9e38735bb64bbf87@mail.gmail.com>
	 <alpine.DEB.2.00.0905262231210.27902@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Wed, 27 May 2009 11:20:37 +0530
Message-Id: <1243403437.3118.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Steve,

On Tue, 2009-05-26 at 22:38 -0400, Steven Rostedt wrote:

> If you look in Documentation/trace/ftrace.txt I have:
> 
> ===
> To mount the debugfs system:
> 
>   # mkdir /debug
>   # mount -t debugfs nodev /debug
> 
> ( Note: it is more common to mount at /sys/kernel/debug, but for
>   simplicity this document will use /debug)
> ===
> 

Please standardize Documentation/trace/ftrace.txt and avoid confusion to
users:

===
To mount the debugfs system:

  # mount -t debugfs nodev /sys/kernel/debug
===

Thanks,
--
JSR

