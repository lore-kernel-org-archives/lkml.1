Return-Path: <linux-kernel-owner+w=401wt.eu-S935233AbZJOVrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935233AbZJOVrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 17:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758144AbZJOVrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 17:47:20 -0400
Received: from foo.birdnet.se ([213.88.146.6]:42401 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756137AbZJOVrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 17:47:19 -0400
Message-ID: <20091015214642.6208.qmail@stuge.se>
Date: Thu, 15 Oct 2009 23:46:42 +0200
From: Peter Stuge <peter@stuge.se>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hardware initialization in line discipline - ldisc_open() ?
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-kernel@vger.kernel.org
References: <20091015205803.30544.qmail@stuge.se> <20091015223137.6b9fb55a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015223137.6b9fb55a@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> > Can you suggest a solution to this problem? Ideally one that can be
> > contained in the ldisc.
> 
> Similar problem with the GSM mux I've been working on. I've gone for
> making the ldisc attach always work and then kicking things off via an
> ioctl which sets the desired mode/parameters/encoding.

I'll do the same. Did you add a new ioctl for this, or use an
existing one?


Thanks!

//Peter
