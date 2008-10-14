Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbYJNSiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbYJNSiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 14:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbYJNSiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 14:38:12 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:7884 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbYJNSiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 14:38:12 -0400
X-IronPort-AV: E=Sophos;i="4.33,410,1220227200"; 
   d="scan'208";a="175027324"
From: Roland Dreier <rdreier@cisco.com>
To: tytso@mit.edu, linux-kernel@vger.kernel.org
Subject: ext2, ext3, ext4 config headlines inconsistent:
X-Message-Flag: Warning: May contain useful information
Date: Tue, 14 Oct 2008 11:37:23 -0700
Message-ID: <adaod1nvx98.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Oct 2008 18:37:24.0258 (UTC) FILETIME=[E682E820:01C92E2B]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

While running an oldconfig with the new kernel, I got the following prompt:

    Second extended fs support (EXT2_FS) [N/m/y/?] n
    Ext3 journalling file system support (EXT3_FS) [N/m/y/?] n
    The Extended 4 (ext4) filesystem (EXT4_FS) [N/m/y/?] (NEW) n

the lack of parallelism in the headline prompts is a little jarring.
Any interest in a patch to make this look uniform, or is it not worth
it?  If you are interested, which variant do you prefer?

Thanks,
  Roland
