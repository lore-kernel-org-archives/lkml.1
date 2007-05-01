Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbXEAWte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbXEAWte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 18:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbXEAWte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 18:49:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795AbXEAWtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 18:49:33 -0400
Message-ID: <4637C3F4.5030800@redhat.com>
Date: Tue, 01 May 2007 18:49:24 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Stephen.Clark@seclark.us
CC: Jesse Barnes <jesse.barnes@intel.com>, Jeff Garzik <jeff@garzik.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates
References: <20070429161542.GA12501@havoc.gtf.org> <46364C04.4050208@garzik.org> <46364FFA.9050500@seclark.us> <200705011438.07499.jesse.barnes@intel.com> <4637C30C.5000109@seclark.us>
In-Reply-To: <4637C30C.5000109@seclark.us>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Clark wrote:
>>
> I'm running fc6 but with kernel 2.6.21 from kernel.org - compiled with
> the .config file from fc6.
> 
> My system is a asus laptop with an ich7 chipset which has both sata and
> pata controllers. My
> laptop only brings out the pata controller interface and both my hd and
> od are on the second
> channel of the pata.
> 
> So can I configure out the old ide and just have ata_piix automatically
> control them both in
> 2.6.21?
> 

Sure, just edit the .config. You may need to play with options to mkinitrd
though; I don't think it will include the PATA drivers for you automatically.


