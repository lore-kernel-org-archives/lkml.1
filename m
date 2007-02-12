Return-Path: <linux-kernel-owner+w=401wt.eu-S965317AbXBLTPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965317AbXBLTPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 14:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965318AbXBLTPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 14:15:14 -0500
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:40965 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965317AbXBLTPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 14:15:08 -0500
Date: Mon, 12 Feb 2007 14:14:41 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Mark de Vries <mark@asphyx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Which CPU for VIA C7/Esther?
Message-ID: <20070212191441.GB20686@athena.road.mcmartin.ca>
References: <1171301858.3557.6.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171301858.3557.6.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 06:37:38PM +0100, Mark de Vries wrote:
> I've been googeling for about an hour now and can't find an answer to:
> What type of CPU should I select when compiling a recent 2.6 kernel if I
> have a VIA Esther CPU?

> stepping        : 9

config MVIAC3_2
        bool "VIA C3-2 (Nehemiah)"
        help
          Select this for a VIA C3 "Nehemiah". Selecting this enables usage
          of SSE and tells gcc to treat the CPU as a 686.
          Note, this kernel will not boot on older (pre model 9) C3s.

Is the one you want, I believe.

Cheers,
	Kyle
