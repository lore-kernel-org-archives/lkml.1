Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbZHJUdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbZHJUdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZHJUdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:33:41 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:21670 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbZHJUdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:33:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAOcggEqrR7MV/2dsb2JhbAC6HIgrjwkFhBg
X-IronPort-AV: E=Sophos;i="4.43,355,1246838400"; 
   d="scan'208";a="89315730"
From: Roland Dreier <rdreier@cisco.com>
To: Greg KH <gregkh@suse.de>
Cc: Bart Van Assche <bart.vanassche@gmail.com>,
       OpenIB <general@lists.openfabrics.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ofa-general] IB kernel modules and the kobject release() method
References: <e2e108260908060943u344bbe03k2baab01b204c9cca@mail.gmail.com>
	<adad478hmi8.fsf@cisco.com>
	<e2e108260908061146y47ae45f5j6b8085d44cd1c45b@mail.gmail.com>
	<adaocqsg339.fsf@cisco.com>
	<e2e108260908061229v2c605aabp7cf66cbe568d6755@mail.gmail.com>
	<adafxc4g1e7.fsf@cisco.com>
	<e2e108260908070026s10658adl2c4a9a5b3eba1a08@mail.gmail.com>
	<20090808034817.GA30697@suse.de>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 10 Aug 2009 13:33:40 -0700
In-Reply-To: <20090808034817.GA30697@suse.de> (Greg KH's message of "Fri, 7
	Aug 2009 20:48:17 -0700")
Message-ID: <adad4738l3v.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Aug 2009 20:33:41.0041 (UTC) FILETIME=[D8EC8210:01CA19F9]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > No, it still makes sense :)

So what's the fix for this?  If even you have trouble understanding
kobject lifetimes and the requirement for a release function, is there
hope for anyone else?

 - R.
