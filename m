Return-Path: <linux-kernel-owner+w=401wt.eu-S1762690AbZDBSiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762690AbZDBSiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756329AbZDBSim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:38:42 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35875 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbZDBSil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:38:41 -0400
Date: Thu, 2 Apr 2009 19:38:34 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: david@lang.hm, Theodore Tso <tytso@mit.edu>,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090402183834.GB4773@srcf.ucam.org>
References: <200903291224.21380.info@gnebu.es> <20090401174336.GA14726@srcf.ucam.org> <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm> <200904030535.00335.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904030535.00335.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 05:34:59AM +1100, Nick Piggin wrote:

> Shouldn't applications have a mode to avoid spinning up the disk if it is
> so important?

They do. It's called "Don't use fsync() unless your data needs to be on 
disk". I'm not sure why you'd ever want an application to be in anything 
but this mode.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
