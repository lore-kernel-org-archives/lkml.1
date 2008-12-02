Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbYLBQak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbYLBQak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 11:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbYLBQac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 11:30:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:24793 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbYLBQab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 11:30:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,702,1220252400"; 
   d="scan'208";a="470335446"
Message-ID: <493562B5.5020600@linux.intel.com>
Date: Tue, 02 Dec 2008 17:30:45 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Jonathan Corbet <corbet@lwn.net>, Al Viro <viro@zeniv.linux.org.uk>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: BUG? "Call fasync() functions without the BKL" is racy
References: <20081128192508.GA21369@redhat.com> <4933CBB0.2060003@linux.intel.com> <20081201191555.GA21385@redhat.com> <20081201123405.51d20d84@bike.lwn.net> <20081202122939.GA3619@redhat.com>
In-Reply-To: <20081202122939.GA3619@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Still I'd like to see the better fix for the long term, the only (afaics)
> flag with the "side effect" is FASYNC, perhaps we can move it to (say)
> ->f_mode, but this is ugly of course and still need serialization for the
> pathes which play with FASYNC.

I wonder if we need FASYNC at all. This could be gotten implicitely by
looking at the fasync_list

-Andi
