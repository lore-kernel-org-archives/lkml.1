Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbYCMUfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbYCMUfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 16:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbYCMUe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 16:34:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbYCMUe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 16:34:56 -0400
Date: Thu, 13 Mar 2008 16:34:31 -0400
From: Rik van Riel <riel@redhat.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: Willy Tarreau <w@1wt.eu>, Chris Friesen <cfriesen@nortel.com>,
       Lars Marowsky-Bree <lmb@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Grzegorz Kulewski <kangur@polcom.net>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080313163431.7b4058ef@cuia.boston.redhat.com>
In-Reply-To: <200803120117.57644.phillips@phunq.net>
References: <200803092346.17556.phillips@phunq.net>
	<200803111256.51267.phillips@phunq.net>
	<20080311205340.GJ8953@1wt.eu>
	<200803120117.57644.phillips@phunq.net>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008 00:17:56 -0800
Daniel Phillips <phillips@phunq.net> wrote:

> So we have a flock of people arguing that you can't trust Linux.  Well
> maybe there are situations were you can't, but what can you trust?
> Disk firmware?  Bios?  Big maybes everywhere.

The traditional and proven method to constructing a reliable system is
to assume that no component can be fully trusted.  This is especially
true for new code.

By being paranoid about everything, failures in one component are
usually contained well enough that one failure is not catastrophic.

In order for ramback to get appeal with the people who are paranoid
about data integrity (probably a vast majority of users), you will
need some guarantees about flush order, etc...

-- 
All Rights Reversed
