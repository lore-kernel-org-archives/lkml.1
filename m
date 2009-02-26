Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbZBZAUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbZBZAUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbZBZAUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:20:31 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:50742 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZBZAUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:20:30 -0500
X-Greylist: delayed 3167 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Feb 2009 19:20:30 EST
To: david@lang.hm
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <matthew@wil.cx>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>
	<49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net>
	<alpine.DEB.1.10.0902251549180.26625@asgard.lang.hm>
	<yq1wsbegj1i.fsf@sermon.lab.mkp.net>
	<alpine.DEB.1.10.0902251609490.26625@asgard.lang.hm>
Date: Wed, 25 Feb 2009 19:20:00 -0500
In-Reply-To: <alpine.DEB.1.10.0902251609490.26625@asgard.lang.hm> (david@lang.hm's message of "Wed\, 25 Feb 2009 16\:13\:42 -0800 \(PST\)")
Message-ID: <yq1fxi2gibz.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49A5E034.01AE:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "david" == david  <david@lang.hm> writes:

david> even if we can't get them to give us any info from the drive
david> directly, we still want to allow the sysadmin to configure the
david> use of the systems when they can find the info in other ways.

You can specify RAID parameters on the mkfs.xfs command line today.
mke[234]fs have similar knobs.


david> if you have the smallest and largest I/O you can submit without a
david> penalty and the alignment, isn't the optimal I/O size everything
david> between these two? (or at least everything between these two may
david> be close enough that defining an 'optimal' size may not be
david> worthwhile)

These parameters come straight out of SCSI.  I described them wrong.
maximum is the biggest I/O the device can handle, full stop.  Optimal is
the preferred I/O size for the array.

-- 
Martin K. Petersen	Oracle Linux Engineering
