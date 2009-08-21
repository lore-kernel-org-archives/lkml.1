Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbZHURok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbZHURok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbZHURoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:44:39 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:44579 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703AbZHURoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:44:38 -0400
X-IronPort-AV: E=Sophos;i="4.44,251,1249257600"; 
   d="scan'208";a="372431268"
From: Roland Dreier <rdreier@cisco.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: [PATCH -mmotm] ummunotify: fix userspace build
References: <200908210222.n7L2Musb015815@imap1.linux-foundation.org>
	<20090821095802.cae7136d.randy.dunlap@oracle.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 21 Aug 2009 10:44:39 -0700
In-Reply-To: <20090821095802.cae7136d.randy.dunlap@oracle.com> (Randy Dunlap's
	message of "Fri, 21 Aug 2009 09:58:02 -0700")
Message-ID: <adaeir5vz7c.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Aug 2009 17:44:39.0951 (UTC) FILETIME=[0EE839F0:01CA2287]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > -HOSTCFLAGS_umn-test.o += -I$(objtree)/include
 > +HOSTCFLAGS_umn-test.o += -I$(objtree)/usr/include

Andrew had the opposite patch in to make things build for him.  I agree
that your way is correct but for some reason it broke Andrew's build.

In any case Andrew dropped ummunotify from mm because I put it into
-next.  (And my version has the /usr/include path)

 - R.
