Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbXCDRZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbXCDRZr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 12:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbXCDRZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 12:25:47 -0500
Received: from ns2.suse.de ([195.135.220.15]:56146 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbXCDRZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 12:25:46 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Guillaume Chazarain" <guichaz@gmail.com>
Subject: Re: [1/3] Bugfix: Don't use the TSC in sched_clock if unstable
Date: Sun, 4 Mar 2007 18:25:38 +0100
User-Agent: KMail/1.9.5
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <3d8471ca0703031341l1768fe7rccf40712e452ea09@mail.gmail.com> <200703041537.27581.ak@suse.de> <3d8471ca0703040741h4eff73a3wd67d648d52497e34@mail.gmail.com>
In-Reply-To: <3d8471ca0703040741h4eff73a3wd67d648d52497e34@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703041825.39361.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 March 2007 16:41, Guillaume Chazarain wrote:
> 2007/3/4, Andi Kleen <ak@suse.de>:
> > What weirdnesses?
> 
> Audio playback skipping (with no xrun), mouse stalls. Total freeze for
> 0.1~0.5 seconds.
> Note that I use the ondemand governor, but I reproduced the audio
> skipping even with
> the performance governor.

On what hardware?  And how many frequency transitions do you have per second?

-Andi
