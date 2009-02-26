Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbZBZDYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbZBZDYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 22:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbZBZDYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 22:24:31 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:51089 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZBZDYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 22:24:31 -0500
To: Matthew Wilcox <matthew@wil.cx>
Cc: Theodore Tso <tytso@mit.edu>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>
	<49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net>
	<20090226025043.GJ1363@mit.edu>
	<20090226030735.GA16891@parisc-linux.org>
Date: Wed, 25 Feb 2009 22:23:25 -0500
In-Reply-To: <20090226030735.GA16891@parisc-linux.org> (Matthew Wilcox's message of "Wed\, 25 Feb 2009 20\:07\:35 -0700")
Message-ID: <yq1myc9g9ua.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.49A60B31.01AF:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Matthew" == Matthew Wilcox <matthew@wil.cx> writes:

Matthew> Lowest aligned logical block address=0

Matthew> This disagrees with Martin's assertion.

The original roadmap was to transition to 4KB sectors in 2006,
coinciding with the Vista release.

Given how long this has taken (we're now talking ~2011 for GA) it may
very well be that the alignment knobs will be unused because everybody
will be using Vista or 7 by then.

That doesn't change the RAID array alignment problem, however.  And we
need to prepare our partitioning tools to align correctly regardless.

-- 
Martin K. Petersen	Oracle Linux Engineering
