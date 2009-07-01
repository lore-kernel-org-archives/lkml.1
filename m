Return-Path: <linux-kernel-owner+w=401wt.eu-S1760360AbZGADlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360AbZGADlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 23:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756668AbZGADlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 23:41:00 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:45715 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbZGADk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 23:40:58 -0400
X-IronPort-AV: E=Sophos;i="4.42,320,1243814400"; 
   d="scan'208";a="207943527"
From: Roland Dreier <rdreier@cisco.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, npiggin@suse.de, chris.mason@oracle.com,
       kurt.hackel@oracle.com, dave.mccracken@oracle.com,
       Avi Kivity <avi@redhat.com>, jeremy@goop.org,
       Rik van Riel <riel@redhat.com>, alan@lxorguk.ukuu.org.uk,
       Rusty Russell <rusty@rustcorp.com.au>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@osdl.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, tmem-devel@oss.oracle.com,
       sunil.mushran@oracle.com, linux-mm@kvack.org,
       Himanshu Raj <rhim@microsoft.com>, linux-embedded@vger.kernel.org
Subject: Re: [RFC] transcendent memory for Linux
References: <5331ec14-c599-4317-bd5b-55911b8ee916@default>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 30 Jun 2009 20:41:01 -0700
In-Reply-To: <5331ec14-c599-4317-bd5b-55911b8ee916@default> (Dan Magenheimer's
	message of "Mon, 29 Jun 2009 07:44:50 -0700 (PDT)")
Message-ID: <aday6r9gjea.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Jul 2009 03:41:01.0630 (UTC) FILETIME=[C0F825E0:01C9F9FD]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > One issue though: I would guess that copying pages of memory
 > could be very slow in an inexpensive embedded processor.

And copying memory could very easily burn enough power by keeping the
CPU busy that you lose the incremental gain of turning the memory off
vs. just going to self refresh.  (And the copying latency would easily
be as bad as the transition latency to/from self-refresh).

 - R.
