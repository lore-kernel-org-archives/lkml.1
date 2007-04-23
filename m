Return-Path: <linux-kernel-owner+w=401wt.eu-S1161395AbXDWTRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161395AbXDWTRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 15:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161397AbXDWTRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 15:17:51 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:21046 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161395AbXDWTRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 15:17:50 -0400
X-IronPort-AV: i="4.14,443,1170662400"; 
   d="scan'208"; a="414675425:sNHT44862256"
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Subject: Re: [PATCH] ib_core: Add missing device link to class device
X-Message-Flag: Warning: May contain useful information
References: <200704231820.27752.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 23 Apr 2007 12:17:48 -0700
In-Reply-To: <200704231820.27752.fenkes@de.ibm.com> (Joachim Fenkes's message of "Mon, 23 Apr 2007 18:20:27 +0200")
Message-ID: <ada7is27vdv.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Apr 2007 19:17:48.0815 (UTC) FILETIME=[1497F1F0:01C785DC]
Authentication-Results: sj-dkim-5; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim5002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, I have links like this on my system already:

    $ ls -l /sys/class/infiniband/mlx4_0/device
    lrwxrwxrwx 1 root root 0 2007-04-23 12:14 /sys/class/infiniband/mlx4_0/device -> ../../../devices/pci0000:00/0000:00:06.0/0000:0d:00.0

the patch actually looks sane but I don't understand why it's needed.
Could you explain?
