Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbYIXW5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbYIXW5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 18:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbYIXW44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 18:56:56 -0400
Received: from twin.jikos.cz ([213.151.79.26]:60530 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbYIXW4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 18:56:55 -0400
Date: Thu, 25 Sep 2008 00:55:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Kyle McMartin <kyle@redhat.com>
cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, jeff@garzik.org, mingo@elte.hu,
       davem@davemloft.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com,
       john.ronciak@intel.com, Bruce Allan <bruce.w.allan@intel.com>
Subject: Re: [PATCH 2/3] e1000e: Useset_memory_ro()/set_memory_rw() to protect
 flash memory
In-Reply-To: <20080924175358.GA2591@phobos.i.cabal.ca>
Message-ID: <Pine.LNX.4.64.0809250054080.27884@twin.jikos.cz>
References: <20080923224535.6869.76210.stgit@jtkirshe-mobile.jf.intel.com>
 <20080924175358.GA2591@phobos.i.cabal.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008, Kyle McMartin wrote:

> [sorry, I've only been following this at a glance, but it's somewhat
>  important for rawhide... does someone have a way to reproduce this at
>  whim? Has someone tried catching it using an IOMMU on one of the newer
>  Intel boxes, if it is a DMA going awry?]

We have a few machines in-house that are affected by this, and they 
currently have EEPROMs of their ethernet cards filled all over with 0xff. 
After Karsten finishes writing the tool to restore the original contents 
of the EEPROM, we will immediately start debugging this.

-- 
Jiri Kosina
SUSE Labs

