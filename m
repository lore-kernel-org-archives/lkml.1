Return-Path: <linux-kernel-owner+w=401wt.eu-S1754258AbZFWSOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbZFWSOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 14:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbZFWSOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 14:14:09 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56589 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbZFWSOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 14:14:09 -0400
Date: Tue, 23 Jun 2009 19:14:09 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: finding reasons for disk spin ups
Message-ID: <20090623181409.GA12814@srcf.ucam.org>
References: <20090623170006.GC30649@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623170006.GC30649@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 07:00:06PM +0200, Norbert Preining wrote:
> Hi all,
> (please cc)
> 
> is there a way I can find the reasons why my disk is spinning up again
> and again? I tried to monitor io with
> 	iotop -o -d 0.01 -b -qqq -t
> but sometimes the disks spins up without anything showing up.
> The partitions are mounted with noatime.
> 
> Is there any kernel interface telling me why/whcih process called for
> the sync so that the disk wakes up?

Yes. /proc/sys/vm/block_dump - set that to 1. Make sure you disable 
syslog first.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
