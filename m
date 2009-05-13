Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbZEMAF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbZEMAF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbZEMAFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:05:49 -0400
Received: from fmailhost06.isp.att.net ([204.127.217.106]:34720 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbZEMAFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:05:48 -0400
X-Originating-IP: [74.251.46.63]
Date: Tue, 12 May 2009 19:05:46 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Frank Filz <ffilzlnx@us.ibm.com>
Cc: Grant Coady <gcoady.lk@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, neilb@suse.de,
       bfields@fieldses.org, linux-nfs@vger.kernel.org
Subject: Re: NFS regression?  Odd delays and lockups accessing an NFS
 export.
Message-ID: <20090512190546.5e8a7faf@osprey.hogchain.net>
In-Reply-To: <1242160078.2404.6.camel@dyn9047022153>
References: <p6lha4te54h04qdbnos1mcemdmn1cfca6s@4ax.com>
	<20080818185048.GO20684@miggy.org>
	<48A9CF89.9090304@bellsouth.net>
	<1242160078.2404.6.camel@dyn9047022153>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009 13:27:58 -0700
Frank Filz <ffilzlnx@us.ibm.com> wrote:

> On Mon, 2008-08-18 at 14:37 -0500, J. K. Cliburn wrote:
> > Athanasius wrote:
> > > On Mon, Aug 18, 2008 at 12:02:20PM +1000, Grant Coady wrote:
> > >> I've been using NFS here for years, lately there's something odd going on 
> > >> since about a month or so.  Previously reported last month:
> > >> http://www.gossamer-threads.com/lists/linux/kernel/951419?page=last
[...]
> > I see you're running the atl1 driver on your client.  I'm chasing an 
> > intermittent bug in that driver that seems to be affected by certain 
> > offload parameters.  Try disabling TSO and see if things improve.
> 
> Was this ever resolved? We're seeing a similar hangup in a 2.6.27
> kernel.

The TSO problem in the atl1 driver was never resolved, and TSO was turned off by default with commit 82c26a9d117f0178b8c1b33429014b6d99c470f6 in the 2.6.27 cycle.  It was also added to the -stable tree at 2.6.26.4.

http://lkml.org/lkml/2008/9/3/251

Jay
