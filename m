Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbYCXT7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbYCXT7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbYCXT7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:59:07 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:46743 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbYCXT7E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:59:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=RJgxaSjBXqe1X8ssRKBiIjfj6+v62lyCPPpPWlG4bpRqis+3t0JkfTWdFyed0knDbJFcPo9QYyv/pRQP839x6C7eLHN3x38A2TVwDGGagM7TOB6csBw1DupR2UtQi3r0zZcRLEM0MTzEw8aoJ8jAwKdnGqOvQscKLVczLGvYhyQ=
Message-ID: <b0943d9e0803241259s5280cdc1o255a4412b3fa7bfc@mail.gmail.com>
Date: Mon, 24 Mar 2008 19:59:00 +0000
From: "Catalin Marinas" <catalin.marinas@gmail.com>
To: git <git@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Stacked GIT 0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stacked GIT 0.14.2 release is available from http://www.procode.org/stgit/.

StGIT is a Python application providing similar functionality to Quilt
(i.e. pushing/popping patches to/from a stack) on top of GIT. These
operations are performed using GIT commands and the patches are stored
as GIT commit objects, allowing easy merging of the StGIT patches into
other repositories using standard GIT functionality.

This is a maintenance release including bug-fixes and a few user
interface enhancements. Acknowledgements:

Catalin Marinas (13):
      Don't set the default authdate if none specified
      Allow pick to import multiple patches
      Check for unnecessary push/pop in 'float'
      Allow the synchronisation of the unapplied patches
      Modify 'series' to use '#' instead of '|'
      Set umask to 0022 during the setup.py execution
      Refuse to send empty patches
      Add a boundary to parse_patches in pick.py
      Fix sync to push the popped patches back after sync'ing
      Remove the reordering side-effect of the latter sync changes
      Allow picking of one commit id
      Remove a newline from the e-mail template
      Release 0.14.2

Onno Kortmann (2):
      Simple rename of top-most patch
      Test the 'stg rename' command

Alex Chiang (1):
      Better "stg rebase" help text

Angus Salkeld (1):
      stg mail crashes when there is no patch description

Karl Hasselström (1):
      Make documentation less confusing

Peter Oberndorfer (1):
      replace "git repo-config" usage by "git config"

Toby Allsopp (1):
      Fix "stg branch --delete" on a nonexistent branch

-- 
Catalin
