Return-Path: <linux-kernel-owner+w=401wt.eu-S932959AbZDIK3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959AbZDIK3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933561AbZDIK27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:28:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43730 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933591AbZDIK26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:28:58 -0400
Date: Thu, 9 Apr 2009 11:28:51 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
       device-mapper development <dm-devel@redhat.com>, ak@linux.intel.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [dm-devel] Barriers still not passing on simple dm devices...
Message-ID: <20090409102851.GT5688@agk.fab.redhat.com>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	device-mapper development <dm-devel@redhat.com>, ak@linux.intel.com,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>
References: <Pine.LNX.4.64.0903251106520.27750@hs20-bc2-1.build.redhat.com> <20090325152751.GV27476@kernel.dk> <Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com> <20090326084205.GG27476@kernel.dk> <Pine.LNX.4.64.0903302314500.6158@hs20-bc2-1.build.redhat.com> <20090331104933.GJ5178@kernel.dk> <Pine.LNX.4.64.0904021923040.19415@hs20-bc2-1.build.redhat.com> <20090403081131.GP5178@kernel.dk> <Pine.LNX.4.64.0904080855340.28196@hs20-bc2-1.build.redhat.com> <1239240440.11220.3.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239240440.11220.3.camel@think.oraclecorp.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 09:27:20PM -0400, Chris Mason wrote:
> I'm afraid expecting barriers forever in the future isn't completely
> compatible with dm or md.  Both of these allow the storage to change
> over time, and the filesystem needs to handle this without corruptions.
 
The missing piece of the jigsaw is notification to upper layers *ahead*
of such reconfigurations.  (We have similar notification issues when
devices are resized - the current approach is to leave the sysadmin
responsible for co-ordinating changes through userspace.)

Alasdair
-- 
agk@redhat.com
