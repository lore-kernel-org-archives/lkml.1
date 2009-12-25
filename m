Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbZLYUL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbZLYUL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 15:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbZLYUL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 15:11:26 -0500
Received: from THUNK.ORG ([69.25.196.29]:56711 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbZLYULZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 15:11:25 -0500
Date: Fri, 25 Dec 2009 15:10:48 -0500
From: tytso@mit.edu
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Eric Sandeen <sandeen@redhat.com>,
       Richard Kennedy <richard@rsk.demon.co.uk>, adilger@sun.com,
       linux-ext4@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext4: return correct wbc.nr_to_write in
 ext4_da_writepages
Message-ID: <20091225201048.GF32757@thunk.org>
Mail-Followup-To: tytso@mit.edu,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Richard Kennedy <richard@rsk.demon.co.uk>, adilger@sun.com,
	linux-ext4@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
References: <1261063063.4882.38.camel@castor>
 <4B2A50E9.4010806@redhat.com>
 <20091217173232.GA2950@skywalker.linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217173232.GA2950@skywalker.linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 11:02:32PM +0530, Aneesh Kumar K.V wrote:
> On Thu, Dec 17, 2009 at 09:40:25AM -0600, Eric Sandeen wrote:
> > Richard Kennedy wrote:
> > > ext4: always re-base nr_to_write in ext4_da_writepages
> > > 
> > > When ext4_da_writepages increases the nr_to_write in writeback_control
> > > then it must always re-base the return value.
> > > 
> > > Without this change, when wb_writeback calculates how many pages were
> > > actually written it can get a negative value and loop more times than
> > > necessary. In tests I have seen nearly all the dirty pages pushed out to
> > > writeback due to this issue.
> > > 
> > > Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

Added to the ext4 patch queue, thanks.

				- Ted
