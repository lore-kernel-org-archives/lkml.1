Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbYARADy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbYARADy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbYARADr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:03:47 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52411 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441AbYARADq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:03:46 -0500
Subject: Merge Candidate tree for the 2.6 kernel
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 18:03:41 -0600
Message-Id: <1200614621.3255.59.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I know ... another tree, just what everyone wants.

This one has a specific purpose: It's my tree tracking everyone else's
git and quilt trees so I get early warning if there are going to be any
merge issues.  However, it struck me it might be useful to anyone
wishing to track what's going upstream more closely.

I'm currently autobuilding it every night with a cron job.  The
resulting log (and patches) are here:

http://www.kernel.org/pub/linux/kernel/people/jejb/merge-tree/

And if you want a git tree, it's here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/merge-tree 2.6.24-rc8-mc1

fully labelled as <kernel version>-mc<n> and the place I began from as
<kernel version>-mc<n>-base.

The file that drives the build is this one:

http://www.kernel.org/pub/linux/kernel/people/jejb/merge-tree-build

As you can see from the reverts and the skips, we have trouble even now
(and that's after I fixed up most of the failures in SCSI).

ACPI and the x86 trees clash hideously, so I kicked out x86

Jens' block tree has two patches which clash with Bart's ide quilt

Greg actually has one patch in his tree that clashes with one of mine.

Please note, this tree is currently very storage centric (i.e. I haven't
included net trees or quilts because I didn't think they'd be likely to
clash with my SCSI trees).  However, if it could be more generally
useful, I could add other trees and quilts to it.

The script that's doing all of this (if you want to try it at home) is:

http://www.kernel.org/pub/linux/kernel/people/jejb/build.pl

James


