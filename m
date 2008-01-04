Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbYADQeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbYADQeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 11:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYADQeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 11:34:04 -0500
Received: from ns2.suse.de ([195.135.220.15]:41189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbYADQeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 11:34:02 -0500
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Eric Whitney <eric.whitney@hp.com>,
       Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: [patch 00/19] VM pageout scalability improvements
From: Andi Kleen <andi@firstfloor.org>
References: <20080102224144.885671949@redhat.com>
	<1199379128.5295.21.camel@localhost>
	<20080103120000.1768f220@cuia.boston.redhat.com>
	<1199380412.5295.29.camel@localhost>
	<20080103170035.105d22c8@cuia.boston.redhat.com>
	<1199463934.5290.20.camel@localhost>
Date: Fri, 04 Jan 2008 17:34:00 +0100
In-Reply-To: <1199463934.5290.20.camel@localhost> (Lee Schermerhorn's message of "Fri\, 04 Jan 2008 11\:25\:34 -0500")
Message-ID: <p73d4sh8s93.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Schermerhorn <Lee.Schermerhorn@hp.com> writes:

> We can easily [he says, glibly] reproduce the hang on the anon_vma lock

Is that a NUMA platform? On non x86? Perhaps you just need queued spinlocks?

-Andi
