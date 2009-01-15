Return-Path: <linux-kernel-owner+w=401wt.eu-S936790AbZAOXBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936790AbZAOXBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933940AbZAOWtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:49:33 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:7255 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935987AbZAOWta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:49:30 -0500
X-IronPort-AV: E=Sophos;i="4.37,272,1231113600"; 
   d="scan'208";a="129133269"
From: Roland Dreier <rdreier@cisco.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: Convert '/' to '!' in dev_set_name()
References: <adaljtjog90.fsf@cisco.com> <adad4evoeu9.fsf@cisco.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 15 Jan 2009 14:49:26 -0800
In-Reply-To: <adad4evoeu9.fsf@cisco.com> (Roland Dreier's message of "Fri, 09
	Jan 2009 22:27:42 -0800")
Message-ID: <adafxjkfamh.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Jan 2009 22:49:27.0493 (UTC) FILETIME=[85142F50:01C97763]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, I still don't see this upstream; I think it should be merged
expeditiously, since it makes some boxes panic on boot.  (One can
generally recover by using dev=<major:minor> instead of dev=/dev/foo/bar
but I still think having tester's boxes panic on boot because of a known
fixed bug is not ideal)
