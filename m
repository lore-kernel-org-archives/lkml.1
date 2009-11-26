Return-Path: <linux-kernel-owner+w=401wt.eu-S1760235AbZKZKS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760235AbZKZKS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 05:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760118AbZKZKSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 05:18:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42274 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759703AbZKZKSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 05:18:54 -0500
Date: Thu, 26 Nov 2009 10:18:59 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: ext Tejun Heo <tj@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: linux-next: workqueues tree build failure
Message-ID: <20091126101859.GA27562@rakim.wolfsonmicro.main>
References: <20091126190050.3f9d7fef.sfr@canb.auug.org.au>
 <200911261016.58810.peter.ujfalusi@nokia.com>
 <4B0E467A.8080201@kernel.org>
 <200911261131.15155.peter.ujfalusi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911261131.15155.peter.ujfalusi@nokia.com>
X-Cookie: 40 isn't old.  If you're a tree.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 11:31:15AM +0200, Peter Ujfalusi wrote:

> For a quick fix, I can convert the tlv320dac33 driver to use this, and revisit 
> later, if it does not fulfill the timing requirements for the HW.

If there are problems then creating a dedicated thread you can wake
would probably do the job.
