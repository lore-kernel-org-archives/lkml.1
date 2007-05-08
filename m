Return-Path: <linux-kernel-owner+w=401wt.eu-S1032182AbXEHVKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032182AbXEHVKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968006AbXEHVKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:10:46 -0400
Received: from 62.sub-75-208-32.myvzw.com ([75.208.32.62]:34697 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967978AbXEHVKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:10:45 -0400
Message-Id: <20070508205129.064843364@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 08 May 2007 13:51:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 0/4] A series of cleanup patches
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi, Andrew,

Here's a series of cleanup patches:

1. add kstrndup, which is needed by
2. add argv_split, a helper for splitting a string into an argv array,
3. a restructuring of the call_usermodehelper set of functions, to make
   them more flexible, needed by
4. a common orderly_poweroff() function, which replaces various ad-hoc
   ways of powering off the machine used around the kernel

Thanks,
	J
-- 

