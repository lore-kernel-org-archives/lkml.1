Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbZJ1Wf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbZJ1Wf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 18:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbZJ1Wfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 18:35:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753497AbZJ1Wfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 18:35:54 -0400
Date: Wed, 28 Oct 2009 15:35:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Zhang Rui <rui.zhang@intel.com>,
       Sujith Thomas <sujith.thomas@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 0/6] [resend] thermal: improvements re. forced passive
 cooling
Message-Id: <20091028153551.6c665ca1.akpm@linux-foundation.org>
In-Reply-To: <1256542744-26569-1-git-send-email-elendil@planet.nl>
References: <1256542744-26569-1-git-send-email-elendil@planet.nl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009 08:38:58 +0100
Frans Pop <elendil@planet.nl> wrote:

> 
> Please consider this patch set for 2.6.32. It was previously submitted
> for 2.6.31, but AFAICT it has not yet been picked up.
> 
> All patches have been acked by either Rui or Matthew, with the
> exception of 1/6 and 4/6, but the entire series has been implicitly
> acked by Rui in http://bugzilla.kernel.org/show_bug.cgi?id=13918#c26.
> 
> The patch set closes http://bugzilla.kernel.org/show_bug.cgi?id=13918.
> 
> Andrew, could you take the set just in case?
> 

I'm trying to work out what the actual bug is in here.

afacit some KDE tool put wrong numbers into /proc files, acpi didn't
sanity check them sufficiently and permitted the CPU to overheat, yes?

There seems to be rather a lot of non-bugfix stuff in this patch
series.  Perhaps too much for 2.6.32, and a real problem if we want to
backport something into 2.6.31.x and earlier.


