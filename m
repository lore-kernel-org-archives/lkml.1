Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbYKDPLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbYKDPLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbYKDPLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:11:32 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:59629 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbYKDPLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:11:31 -0500
Date: Tue, 4 Nov 2008 15:11:28 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Add option to passively listen for PCIE hotplug events
Message-ID: <20081104151128.GA22544@srcf.ucam.org>
References: <bspwK-420-11@gated-at.bofh.it> <bujnh-2fr-5@gated-at.bofh.it> <bujwT-2Ew-5@gated-at.bofh.it> <buml1-6du-3@gated-at.bofh.it> <d51a1b7b-32db-41dd-a36d-911ed62f5cb4@l33g2000pri.googlegroups.com> <20081104124706.GB19401@srcf.ucam.org> <20081104133214.GA20427@srcf.ucam.org> <49105BA6.9090403@tuffmail.co.uk> <20081104143332.GA21689@srcf.ucam.org> <491063B3.4080808@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491063B3.4080808@tuffmail.co.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 03:01:07PM +0000, Alan Jenkins wrote:

> Hey... you're making this conditional on whether a power led is reported
> present, right?  Are you sure the EeePC doesn't report itself as having
> a power led?

Doesn't seem to on the one I was testing, but it's possible. Any chance 
you could instrument it? There's only a few calls to msleep in 
pcihp_ctrl.c.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
