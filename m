Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbYJ1WDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbYJ1WDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 18:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYJ1WDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 18:03:23 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:40294 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbYJ1WDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 18:03:22 -0400
X-IronPort-AV: E=Sophos;i="4.33,501,1220227200"; 
   d="scan'208";a="184346028"
From: Roland Dreier <rdreier@cisco.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, Glauber Costa <glommer@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       aliguori@codemonkey.ws, npiggin@suse.de,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: [PATCH] regression: vmalloc easily fail.
References: <1225234513-3996-1-git-send-email-glommer@redhat.com>
	<49077E1A.5080105@redhat.com> <ada7i7so1o7.fsf@cisco.com>
	<20081028144255.05712d70@infradead.org>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 28 Oct 2008 15:03:20 -0700
In-Reply-To: <20081028144255.05712d70@infradead.org> (Arjan van de Ven's
	message of "Tue, 28 Oct 2008 14:42:55 -0700")
Message-ID: <adad4hkml7b.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Oct 2008 22:03:20.0590 (UTC) FILETIME=[FD3E0AE0:01C93948]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I suspect it's a case of off-by-one... ALIGN() might round down, and
 > the "+ (PAGE_SIZE-1)" was there to make it round up.
 > Except for that missing -1 ...

ALIGN() has always rounded up, at least back to 2.4.
