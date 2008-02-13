Return-Path: <linux-kernel-owner+w=401wt.eu-S932731AbYBMJ2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731AbYBMJ2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762628AbYBMJ15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:27:57 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:53435 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766011AbYBMJ1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:27:55 -0500
Subject: Re: [RFC PATCH] RTTIME watchdog timer proc interface
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <47B21C01.9070608@ct.jp.nec.com>
References: <47B0C1D4.5080808@ct.jp.nec.com>
	 <1202766767.6247.16.camel@lappy>  <47B21C01.9070608@ct.jp.nec.com>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 10:27:49 +0100
Message-Id: <1202894869.14326.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-12 at 14:21 -0800, Hiroshi Shimamoto wrote:
> Peter Zijlstra wrote:
> > On Mon, 2008-02-11 at 13:44 -0800, Hiroshi Shimamoto wrote:
> >> Hi Ingo,
> >>
> >> I think an interface to access RLIMIT_RTTIME from outside is useful.
> >> It makes administrator able to set RLIMIT_RTTIME watchdog to existing
> >> real-time applications without impact.
> >>
> >> I implemented that interface with /proc filesystem.
> > 
> > /proc/<pid>/tasks/<tid>/rttime might also make sense.
> > 
> thanks, I'll add.

I just realized that because its an rlimit, we store these values
process-wide. The per task thing was a feature request from someone, and
I just jumped on your interface without proper consideration.

I'll need to think a bit more on this

