Return-Path: <linux-kernel-owner+w=401wt.eu-S1758963AbZFJJi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963AbZFJJi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756654AbZFJJiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:38:02 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40271 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbZFJJh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:37:58 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting
Date: Wed, 10 Jun 2009 09:30:41 +0100
Message-Id: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As the merge window is more or less upon us, here is the content
of the GFS2 -nmw tree. There is nothing too startling this time
as the focus has very much been bug fixes and clean up.

We have a new mount option, commit= which does exactly the same
thing as the ext3 equivalent option. We have a long term plan to
make all the tunable parameters available as mount options and
thus to be able to eventually drop the sysfs interface to these
parameters.

Another long term plan is to get rid of the files named
ops_somethingorother and to either merge them into other
files, or rename them to not have the ops_ prefix. This
patch series makes a start on that, and does all the easy
ones. As a result some functions with only one caller are
moved to the same file as their caller and made static.

The docs are also updated to reflect the fact that the
lock_dlm interface module no longer exists and that interface is
now built into GFS2.

Steve.


