Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbYJ3RSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbYJ3RSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbYJ3RS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:18:29 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:36395 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbYJ3RS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:18:28 -0400
Message-ID: <4909EC14.4070905@s5r6.in-berlin.de>
Date: Thu, 30 Oct 2008 18:17:08 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.17) Gecko/20080829 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: merging other repos into linux-2.6
References: <20081030054944.GA19035@kroah.com>
In-Reply-To: <20081030054944.GA19035@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> In working with some of the current out-of-tree drivers, some of them
> are asking if they could keep their past development history when
> merging the code into the main kernel tree.
> 
> Now normally we don't do this for new drivers, just dropping them in in
> one big patch, or sometimes multiple patches to get it through email
> filters.
> 
> The comedi group (data acquisition subsystem for Linux) have their whole
> history going back to 2000 in a git tree (well, a cvs->git repo.)
> 
> I was wondering if it would be acceptable to graft their tree into the
> linux-2.6 tree (after moving the files to the proper location) to keep
> their whole old history alive.
> 
> Now what good that old history would do, I really don't know and can't
> think of a solid reason to need it, other than to give proper authorship
> credit for the various individual drivers and parts of the code (which
> is good to have at tims.)
[...]

There can be other reasons to keep the history in /some/ publicly
accessible repo (maybe not in the mainline though):
  - Changelogs sometimes explain why something was written in a
    specific way, which may not be obvious from the code or comments.
  - Some modifications during mainline merge preparation, e.g.
    simplifications, may turn out undesirable later and one wants to
    revert some of such modifications.
-- 
Stefan Richter
-=====-==--- =-=- ====-
http://arcgraph.de/sr/
