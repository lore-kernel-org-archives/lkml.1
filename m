Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbYBRDJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbYBRDJX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 22:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbYBRDJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 22:09:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632AbYBRDJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 22:09:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Rob Landley <rob@landley.net>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: Compiling with 2.6.25-rc2 with binutils 2.17 fails?
In-Reply-To: Rob Landley's message of  Saturday, 16 February 2008 17:27:21 -0600 <200802161727.21312.rob@landley.net>
References: <200802161727.21312.rob@landley.net>
X-Zippy-Says: I'm QUIETLY reading the latest issue of ``BOWLING WORLD'' while my
    wife and two children stand QUIETLY BY..
Message-Id: <20080218030910.C2CB1270195@magilla.localdomain>
Date: Sun, 17 Feb 2008 19:09:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Still trying to track down why, but it works on a toolchain built from 
> binutils 2.18 and gcc 4.1.3, but not with a toolchain from binutils 2.17 and 
> gcc 4.1.2.  And considering where it's failing...

I don't think the vdso magic should require so new a binutils.  Please try
to figure out which of the steps is producing different results between the
two tool setups.


Thanks,
Roland
