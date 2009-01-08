Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbZAHMaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbZAHMaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbZAHM36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:29:58 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:21268 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753328AbZAHM35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:29:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAD9+ZUl5LM4Z/2dsb2JhbADOVQaFbw
X-IronPort-AV: E=Sophos;i="4.37,233,1231075800"; 
   d="scan'208";a="261749207"
Date: Thu, 8 Jan 2009 23:29:53 +1100
From: Peter Moulder <pjrm@mail.internode.on.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Cc: =?iso-8859-1?Q?=C9ric?= Piel <E.A.B.Piel@tudelft.nl>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH, resend] relatime: Let relatime update atime at least
	once per day
Message-ID: <20090108122952.GA19743@mail.internode.on.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081228152901.GB13565@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What was the fate of Ingo's previous patch[*1] to implement this (which,
incidentally, also included updates to documentation and made the interval
configurable as Éric Piel suggests) ?

[*1]: http://lwn.net/Articles/244384/


Just a minor nit, but the patch description (not included in the patch itself)
"at least once a day" isn't particularly accurate given that the patch enforces
at least a day [minus a second or so] has elapsed since the last update.  The
description in the above-referenced patch "only once a day" better captures the
situation, I think.

pjrm.
