Return-Path: <linux-kernel-owner+w=401wt.eu-S1761661AbYBHWdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761661AbYBHWdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbYBHW1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:27:14 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52604 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758113AbYBHW1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:27:08 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 8 Feb 2008 23:26:02 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] stable_kernel_rules: fix must already be in mainline
To: Greg KH <gregkh@suse.de>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080208013504.GA3891@suse.de>
Message-ID: <tkrat.eb4a03c77d59701f@s5r6.in-berlin.de>
References: <20080207204549.GA16389@suse.de> <20080208004430.GE155407@sgi.com>
 <20080208011230.GA28390@kroah.com> <20080208012457.GI155407@sgi.com>
 <20080208013504.GA3891@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On  7 Feb, Greg KH wrote:
> On Fri, Feb 08, 2008 at 12:24:57PM +1100, David Chinner wrote:
>> On Thu, Feb 07, 2008 at 05:12:30PM -0800, Greg KH wrote:
>> > On Fri, Feb 08, 2008 at 11:44:30AM +1100, David Chinner wrote:
>> > > We've had multiple reports of it, and multiple confirmations that
>> > > the patch in the link above fixes the problem.....
>> > 
>> > I didn't think it was in Linus's tree yet.  Is it?
>> 
>> Not yet - it's in the pipeline. I'll see if that can be sped
>> up (someone else usually takes care of the pushes to Linus).
> 
> Then we did our job right and didn't take it :)
> 
> Please resend it after it gets into Linus's tree, not before, I'm really
> tired of checking for these things constantly...

----------------
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

stable_kernel_rules: fix must already be in mainline

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 Documentation/stable_kernel_rules.txt |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.24-git19/Documentation/stable_kernel_rules.txt
===================================================================
--- linux-2.6.24-git19.orig/Documentation/stable_kernel_rules.txt
+++ linux-2.6.24-git19/Documentation/stable_kernel_rules.txt
@@ -16,8 +16,9 @@ Rules on what kind of patches are accept
    race can be exploited is also provided.
  - It cannot contain any "trivial" fixes in it (spelling changes,
    whitespace cleanups, etc).
- - It must be accepted by the relevant subsystem maintainer.
  - It must follow the Documentation/SubmittingPatches rules.
+ - It or an equivalent fix must already exist in Linus' tree.  Quote the
+   respective commit ID in Linus' tree in your patch submission to -stable.
 
 
 Procedure for submitting patches to the -stable tree:
@@ -28,7 +29,7 @@ Procedure for submitting patches to the 
    queue, or a NAK if the patch is rejected.  This response might take a few
    days, according to the developer's schedules.
  - If accepted, the patch will be added to the -stable queue, for review by
-   other developers.
+   other developers and by the relevant subsystem maintainer.
  - Security patches should not be sent to this alias, but instead to the
    documented security@kernel.org address.
 

-- 
Stefan Richter
-=====-==--- --=- -=---
http://arcgraph.de/sr/

