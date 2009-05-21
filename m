Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbZEUTVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbZEUTVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 15:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbZEUTVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 15:21:36 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:2096 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbZEUTVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 15:21:35 -0400
Date: Thu, 21 May 2009 16:17:04 -0300
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       linux-raid@vger.kernel.org, agk@redhat.com, neilb@suse.de
Subject: Re: [RFC PATCH] dm-csum: A new device mapper target that checks
	data integrity
Message-ID: <20090521191704.GX1376@blitiri.com.ar>
References: <20090521161317.GU1376@blitiri.com.ar> <87f94c370905211117y13758f72i2ea113c9c6771061@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87f94c370905211117y13758f72i2ea113c9c6771061@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2008-03-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 02:17:58PM -0400, Greg Freemyer wrote:
> On Thu, May 21, 2009 at 12:13 PM, Alberto Bertogli
> <albertito@blitiri.com.ar> wrote:
> > I'm writing this device mapper target that stores checksums on writes and
> > verifies them on reads.
> 
> I have not looked at your patch, but does this tie into the integrity
> logic that was added to mainline a few months ago?

At the moment it has no relation, but making dm-csum devices register with the
bio integrity extensions is on my to-do list, and the on-disk format already
reserves 32 bits for every 512-byte sector for tagging purposes.

Thanks,
		Alberto

