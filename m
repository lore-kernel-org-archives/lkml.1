Return-Path: <linux-kernel-owner+w=401wt.eu-S1757670AbZFXS3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670AbZFXS3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZFXS3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:29:38 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:47620 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbZFXS3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:29:38 -0400
Date: Wed, 24 Jun 2009 20:29:36 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, hjk@linutronix.de
Subject: Re: [PATCH 1/2] UIO: add device clock support
Message-ID: <20090624182936.GY29236@buzzloop.caiaq.de>
References: <1245857425-25389-1-git-send-email-daniel@caiaq.de> <1245857425-25389-2-git-send-email-daniel@caiaq.de> <20090624163414.GB26409@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624163414.GB26409@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 09:34:14AM -0700, Greg KH wrote:
> On Wed, Jun 24, 2009 at 05:30:24PM +0200, Daniel Mack wrote:
> > Add a pointer to a 'struct clk' to uio_info. Drivers can set
> > this pointer if a clock is needed, and the UIO core will care
> > to enable and disable it upon device open and release.
> 
> Do you have a UIO driver that needs this?

No.

> If so, please submit it at the same time, otherwise adding
> infrastructure for no driver that needs it, is pretty pointless.

As I wrote in my introduction email, I wanted to use this framework but
eventually I didn't. But then I had these patches flying around and I
thought sharing them is better than throwing them away. They work well,
it's just that this particular feature has no uses at the moment.

Anyway, feel free to discard them if you don't like them. Just wanted to
let you know :)

Daniel
