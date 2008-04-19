Return-Path: <linux-kernel-owner+w=401wt.eu-S1761747AbYDSOSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761747AbYDSOSd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 10:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbYDSOS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 10:18:26 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:29695 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbYDSOSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 10:18:25 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ralph Campbell <ralph.campbell@qlogic.com>,
       Dave Olson <dave.olson@qlogic.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [GIT PULL] please pull infiniband.git
References: <adaskxkh6s2.fsf@cisco.com> <20080419081614.GA2437@elte.hu>
	<adaod86aq9j.fsf@cisco.com>
X-Message-Flag: Warning: May contain useful information
Date: Sat, 19 Apr 2008 07:18:24 -0700
In-Reply-To: <adaod86aq9j.fsf@cisco.com> (Roland Dreier's message of "Sat, 19
	Apr 2008 07:11:20 -0700")
Message-ID: <adak5iuapxr.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Apr 2008 14:18:24.0654 (UTC) FILETIME=[3AA802E0:01C8A228]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the way (only peripherally related), it seems all the #ifdef
CONFIG_PCI_MSI tests in ipath_iba7220.c can be removed, since the code
should work fine even if PCI_MSI is not set...

 - R.
