Return-Path: <linux-kernel-owner+w=401wt.eu-S1763963AbXFRSdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763963AbXFRSdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759353AbXFRSd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:33:26 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:60227 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759273AbXFRSdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:33:25 -0400
X-Greylist: delayed 1797 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jun 2007 14:33:25 EDT
Date: Mon, 18 Jun 2007 14:33:24 -0400
To: david@lang.hm
Cc: Brendan Conoboy <blc@redhat.com>, Neil Brown <neilb@suse.de>,
       Wakko Warner <wakko@animx.eu.org>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: limits on raid
Message-ID: <20070618183324.GL10006@csclub.uwaterloo.ca>
References: <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org> <18035.23867.576212.859440@notabene.brown> <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm> <4676BEC2.7090809@redhat.com> <Pine.LNX.4.64.0706181026170.12717@asgard.lang.hm> <20070618180327.GP10008@csclub.uwaterloo.ca> <Pine.LNX.4.64.0706181111020.12717@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706181111020.12717@asgard.lang.hm>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 11:12:45AM -0700, david@lang.hm wrote:
> simple ultra-wide SCSI to a single controller.

Hmm, isn't ultra-wide limited to 40MB/s?  Is it Ultra320 wide?  That
could do a lot more, and 220MB/s sounds plausable for 320 scsi.

> I didn't realize that the rate reported by /proc/mdstat was the write 
> speed that was takeing place, I thought it was the total data rate (reads 
> + writes). the next time this message gets changed it would be a good 
> thing to clarify this.

Well I suppose itcould make sense to show rate of rebuild which you can
then compare against the total size of tha raid, or you can have rate of
write, which you then compare against the size of the drive being
synced.  Certainly I would expect much higer speeds if it was the
overall raid size, while the numbers seem pretty reasonable as a write
speed.  4MB/s would take for ever if it was the overall raid resync
speed.  I usually see SATA raid1 resync at 50 to 60MB/s or so, which
matches the read and write speeds of the drives in the raid.

--
Len Sorensen
