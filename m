Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbXGHNnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbXGHNnh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 09:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbXGHNnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 09:43:31 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:26261 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbXGHNna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 09:43:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAP+GkEarR7PE/2dsb2JhbAA
X-IronPort-AV: i="4.16,513,1175497200"; 
   d="scan'208"; a="178438000:sNHT24681762"
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH 11/20] KVM: SVM: Reliably detect if SVM was disabled by BIOS
X-Message-Flag: Warning: May contain useful information
References: <11838956891287-git-send-email-avi@qumranet.com>
	<11838956892580-git-send-email-avi@qumranet.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 08 Jul 2007 06:43:26 -0700
In-Reply-To: <11838956892580-git-send-email-avi@qumranet.com> (Avi Kivity's message of "Sun,  8 Jul 2007 14:54:40 +0300")
Message-ID: <aday7hr105d.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Jul 2007 13:43:26.0903 (UTC) FILETIME=[F6281C70:01C7C165]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

seems like we probably want this for 2.6.22... it fixes a panic that
I've seen actually reported by several users.  Is there any risk to
merging it?

i guess getting it into 2.6.22.1 would be OK too.
