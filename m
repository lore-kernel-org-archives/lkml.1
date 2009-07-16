Return-Path: <linux-kernel-owner+w=401wt.eu-S932995AbZGPSPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbZGPSPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 14:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932963AbZGPSPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 14:15:23 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59048 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932870AbZGPSPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 14:15:22 -0400
Date: Thu, 16 Jul 2009 12:15:21 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: david@lang.hm
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: deterministic scsi order with async scan
Message-ID: <20090716181521.GT24310@parisc-linux.org>
References: <alpine.DEB.1.10.0907151801040.9159@asgard> <20090716115703.GQ24310@parisc-linux.org> <alpine.DEB.1.10.0907161022540.9159@asgard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0907161022540.9159@asgard>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 10:23:45AM -0700, david@lang.hm wrote:
> hmm, in that case how can I troubleshoot why this system is detecting the 
> two different PCI-E cards in different orders on different boots.

I don't know.  Are the cards actually being detected in a different
order, or are the Linux drivers being bound to them in a different order?
Are you using modules or are these drivers built-in?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
