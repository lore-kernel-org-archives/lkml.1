Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbYFHXLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbYFHXLB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 19:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755919AbYFHXKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 19:10:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:12132 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859AbYFHXKt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 19:10:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Djyj9k1nH08fhJJo5oKyd9urkrfsUnlD0ACjJpQXDg/lWjHsY40nceGmrgGDKocK5Q
         0r37VJawFXtJr3S+Srd6MjiiNlXe4WSvfVAaMxMulS2VN3flGzwYcMJmyQJ228rn66q8
         xgdFDExtnMzoT18a+uWWRQXiSMI5tL0byVD74=
Message-ID: <b0943d9e0806081610n6f504a4wc2af285aa2c48d1a@mail.gmail.com>
Date: Mon, 9 Jun 2008 00:10:47 +0100
From: "Catalin Marinas" <catalin.marinas@gmail.com>
To: git <git@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Stacked GIT 0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stacked GIT 0.14.3 release is available from http://www.procode.org/stgit/.

StGIT is a Python application providing similar functionality to Quilt
(i.e. pushing/popping patches to/from a stack) on top of GIT. These
operations are performed using GIT commands and the patches are stored
as GIT commit objects, allowing easy merging of the StGIT patches into
other repositories using standard GIT functionality.

This is a maintenance release including bug-fixes for the "refresh"
command, handling of file names with non-ASCII characters and user
interface enhancements for "export" and "sync".

Acknowledgements:

Karl Hasselström (6):
      Fix problems in t1000-branch-create
      Make t1003-new executable
      Add rebase test for when upstream has deleted a non-ASCII file
      Handle changed files with non-ASCII names
      Test for another filename quoting issue in tree_status()
      Handle refresh of changed files with non-ASCII names

Catalin Marinas (4):
      Fix the sync'ing of unapplied patches only
      Allow export to write unapplied files as well
      Fix "refresh" failure with moved files (bug 11661)
      Release 0.14.3

-- 
Catalin
