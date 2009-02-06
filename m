Return-Path: <linux-kernel-owner+w=401wt.eu-S1757424AbZBFSGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbZBFSGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZBFSF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:05:59 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:41744 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbZBFSF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:05:58 -0500
X-IronPort-AV: E=Sophos;i="4.37,392,1231113600"; 
   d="scan'208";a="244417950"
From: Roland Dreier <rdreier@cisco.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: riku.voipio@iki.fi, rpurdie@rpsys.net, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] leds: always true: (x != 1 || x != 2)
References: <498863FC.1090008@gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 06 Feb 2009 10:05:57 -0800
In-Reply-To: <498863FC.1090008@gmail.com> (Roel Kluin's message of "Tue, 03
	Feb 2009 16:34:20 +0100")
Message-ID: <adaiqnnxwxm.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Feb 2009 18:05:57.0415 (UTC) FILETIME=[8F5EC370:01C98885]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > -	if (type != EV_SND && (code != SND_BELL || code != SND_TONE))
 > +	if (type != EV_SND && (code != SND_BELL && code != SND_TONE))

Actually more likely seems to be

	if (type != EV_SND || (code != SND_BELL && code != SND_TONE))
