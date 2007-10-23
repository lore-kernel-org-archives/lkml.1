Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbXJWQtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbXJWQtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbXJWQtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:49:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbXJWQs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:48:59 -0400
Subject: Re: [PATCH] Add eeprom_bad_csum_allow module option to e1000.
From: Adam Jackson <ajax@redhat.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <471E1ECD.80002@intel.com>
References: <11931515302013-git-send-email-ajax@redhat.com>
	 <471E1ECD.80002@intel.com>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 12:21:27 -0400
Message-Id: <1193156487.26974.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.90 (2.11.90-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-23 at 09:18 -0700, Kok, Auke wrote:
> Adam Jackson wrote:
> > When the EEPROM gets corrupted, you can fix it with ethtool, but only if
> > the module loads and creates a network device.  But, without this option,
> > if the EEPROM is corrupted, the driver will not create a network device.
> > 
> > Signed-off-by: Adam Jackson <ajax@redhat.com>
> 
> NAK
> 
> wrong list, not sent to me, and while for e100 I was OK with this patch, for e1000
> it really does not make sense to 'just allow' a bad checksum - if your eeprom is
> randomly messed up then you cannot just fix it like this anyway.

That's strange, I managed to recover an otherwise horked e1000 with it.
What should I have done instead?

- ajax

