Return-Path: <linux-kernel-owner+w=401wt.eu-S1757169AbYBSNee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbYBSNee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 08:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbYBSNeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 08:34:17 -0500
Received: from lw.wurtel.net ([82.192.92.211]:1709 "EHLO lw.wurtel.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbYBSNeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 08:34:16 -0500
X-Greylist: delayed 1199 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2008 08:34:15 EST
Date: Tue, 19 Feb 2008 14:14:12 +0100
From: Paul Slootman <paul@wurtel.net>
To: linux-kernel@vger.kernel.org
Subject: Re: very poor ext3 write performance on big filesystems?
Message-ID: <20080219131412.GA2255@msgid.wurtel.net>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <9YdLC-75W-51@gated-at.bofh.it> <9YeRh-Gq-39@gated-at.bofh.it> <9Yf0W-SX-19@gated-at.bofh.it> <9YfNi-2da-23@gated-at.bofh.it> <9YfWL-2pZ-1@gated-at.bofh.it> <9Yg6H-2DJ-23@gated-at.bofh.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9Yg6H-2DJ-23@gated-at.bofh.it>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 18 Feb 2008, Andi Kleen wrote:
> On Mon, Feb 18, 2008 at 10:16:32AM -0500, Theodore Tso wrote:
> > On Mon, Feb 18, 2008 at 04:02:36PM +0100, Tomasz Chmielewski wrote:
> > > I tried to copy that filesystem once (when it was much smaller) with "rsync 
> > > -a -H", but after 3 days, rsync was still building an index and didn't copy 
> > > any file.
> > 
> > If you're going to copy the whole filesystem don't use rsync! 
> 
> Yes, I managed to kill systems (drive them really badly into oom and
> get very long swap storms) with rsync -H in the past too. Something is very 
> wrong with the rsync implementation of this.

Note that the soon-to-be-released version 3.0.0 of rsync has very much
improved performance here, both in speed and memory usage, thanks to a
new incremental transfer protocol (before it read in the complete file
list, first on the source, then on the target, and then only started to
do the actual work).


Paul Slootman
