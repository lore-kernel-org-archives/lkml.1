Return-Path: <linux-kernel-owner+w=401wt.eu-S964937AbXA3AWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964937AbXA3AWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 19:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965085AbXA3AWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 19:22:20 -0500
Received: from main.gmane.org ([80.91.229.2]:49685 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964937AbXA3AWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 19:22:18 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ben Pfaff <blp@cs.stanford.edu>
Subject: slow module build--what am I doing wrong?
Date: Mon, 29 Jan 2007 16:22:26 -0800
Message-ID: <87ps8xicsd.fsf@blp.benpfaff.org>
Reply-To: blp@cs.stanford.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: c-24-7-50-23.hsd1.ca.comcast.net
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
Cancel-Lock: sha1:59ddnJJOiCBET91XsNWb55lK5MI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When I modify a source file or two that belong to a particular
module, and then rebuild just that module with "make
dir1/dir/module.ko" (e.g.), the build system spends a couple of
minutes grinding away on "MODPOST" operations.  Am I doing
something wrong?  Is there a way to avoid this?  It slows down my
build-and-test cycle quite a bit.

Thanks!
-- 
Ben Pfaff 
blp@cs.stanford.edu
http://benpfaff.org

