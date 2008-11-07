Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbYKGBzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbYKGBzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 20:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYKGBzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 20:55:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50723 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbYKGBzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 20:55:20 -0500
Date: Thu, 6 Nov 2008 18:54:11 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Norbert Preining <preining@logic.at>, Mattia Dongili <malattia@linux.it>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usb device not showing up
Message-Id: <20081106185411.144984ab.zaitcev@redhat.com>
In-Reply-To: <Pine.LNX.4.44L0.0811061423510.23473-100000@iolanthe.rowland.org>
References: <20081106171958.GA17270@gamma.logic.tuwien.ac.at>
	<Pine.LNX.4.44L0.0811061423510.23473-100000@iolanthe.rowland.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008 14:34:53 -0500 (EST), Alan Stern <stern@rowland.harvard.edu> wrote:

> I have to wonder...  Did you remove any part of the trace?  Did usbmon 
> malfunction?  Did parts of the initialization for those two buses 
> really get skipped (I can't imagine how)?
> 
> Pete, any ideas?

It is possible for usbmon to lose events. There's a counter to
monitor it, in 0s file. I do not commonly run across such problems,
but it can happen. If it's a problem, one can try to bump the limits
way higher, if RAM allows.

-- Pete
