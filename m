Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbZI3KA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbZI3KA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 06:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbZI3KA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 06:00:56 -0400
Received: from 8bytes.org ([88.198.83.132]:52316 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbZI3KA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 06:00:56 -0400
Date: Wed, 30 Sep 2009 12:00:59 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: linux-kernel@vger.kernel.org, bhavna.sarathy@amd.com, davej@redhat.com
Subject: Re: [PATCH] Option to synchronize P-states for  AMD family 0xf
Message-ID: <20090930100059.GG29634@8bytes.org>
References: <200909291623.56130.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909291623.56130.mark.langsdorf@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 04:23:55PM -0500, Mark Langsdorf wrote:

> AMD Family 0xf processors (Athlon 64s and Opterons) do not
> have P-State or C-State invariant TSCs.  Instead, the TSC
> increments at the current processor frequency, which makes
> it unstable and unreliable if cpufreq is enabled.
> 
> This patch introduces a new command parameter for the
> PowerNow! driver called "tscsync".  When tscsync is
> set to 1, the driver forces all processors in the system
> to change frequency as the same time to the same frequency.
> This unified change means that all the TSCs in the system
> increment at the same rate.

Cool feature. Does Linux consider the TSC as stable on these machines
even after a longer uptime (say after a week)?

	Joerg

