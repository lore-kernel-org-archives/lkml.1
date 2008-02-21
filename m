Return-Path: <linux-kernel-owner+w=401wt.eu-S935684AbYBUWy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935684AbYBUWy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760269AbYBUWyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:54:10 -0500
Received: from mx2.netapp.com ([216.240.18.37]:49591 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935497AbYBUWyG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:54:06 -0500
X-IronPort-AV: E=Sophos;i="4.25,388,1199692800"; 
   d="scan'208";a="211603"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 00/37] Permit filesystem local caching
Date: Thu, 21 Feb 2008 14:52:51 -0800
Message-ID: <01AE8AF878612047A442668306EAEB0501A36EDA@SACEXMV01.hq.netapp.com>
In-reply-to: <200802211444.04986.phillips@phunq.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 00/37] Permit filesystem local caching
Thread-Index: Ach022kuH0t4zO1KQ6a7QKBRN0LbbAAACUeg
References: <200802201907.40406.phillips@phunq.net><20080220160557.4715.66608.stgit@warthog.procyon.org.uk><28196.1203605703@redhat.com> <200802211444.04986.phillips@phunq.net>
From: "Muntz, Daniel" <Dan.Muntz@netapp.com>
To: "Daniel Phillips" <phillips@phunq.net>,
       "David Howells" <dhowells@redhat.com>
Cc: "Myklebust, Trond" <Trond.Myklebust@netapp.com>, <nfsv4@linux-nfs.org>,
       <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
       <linux-security-module@vger.kernel.org>, <selinux@tycho.nsa.gov>,
       <casey@schaufler-ca.com>
X-OriginalArrivalTime: 21 Feb 2008 22:53:49.0477 (UTC) FILETIME=[9F540550:01C874DC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, the AFS paper that was referenced earlier was written around the
time of 10bt and 100bt.  Local disk caching worked well then.  There
should also be some papers at CITI about disk caching over slower
connections, and disconnected operation (which should still be
applicable today).  There are still winners from local disk caching, but
their numbers have been reduced.  Server load reduction should be a win.
I'm not sure if it's worth it from a security/manageability standpoint,
but I haven't looked that closely at David's code.

  -Dan

-----Original Message-----
From: Daniel Phillips [mailto:phillips@phunq.net] 
Sent: Thursday, February 21, 2008 2:44 PM
To: David Howells
Cc: Myklebust, Trond; nfsv4@linux-nfs.org; linux-kernel@vger.kernel.org;
linux-fsdevel@vger.kernel.org; linux-security-module@vger.kernel.org;
selinux@tycho.nsa.gov; casey@schaufler-ca.com
Subject: Re: [PATCH 00/37] Permit filesystem local caching

Hi David,

I am trying to spot the numbers that show the sweet spot for this
optimization, without much success so far.

Who is supposed to win big?  Is this mainly about reducing the load on
the server, or is the client supposed to win even with a lightly loaded
server?

When you say Ext3 cache vs NFS cache is the first on the server and the
second on the client?

Regards,

Daniel
_______________________________________________
NFSv4 mailing list
NFSv4@linux-nfs.org
http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4
