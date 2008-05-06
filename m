Return-Path: <linux-kernel-owner+w=401wt.eu-S1763626AbYEFPS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763626AbYEFPS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbYEFPSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:18:51 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37191 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754884AbYEFPSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:18:50 -0400
X-Sasl-enc: jzGbMm2+3aBp+VyB5YGgyvhXRdfAG2zD3nzgIUOds/CE 1210087128
Date: Tue, 6 May 2008 12:18:46 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Holger Macht <hmacht@suse.de>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Accardi, Kristen C" <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] bay: Exit if notify handler cannot be installed
Message-ID: <20080506151846.GA22828@khazad-dum.debian.net>
References: <20080505202508.GA3690@homac> <20080506091522.GA4378@homac> <1210065811.12668.1.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210065811.12668.1.camel@sli10-desk.sh.intel.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 May 2008, Shaohua Li wrote:
> The bay driver is duplicated with libata, I thought we should delete it.
> See bug http://bugzilla.kernel.org/show_bug.cgi?id=9526

The bay driver is currently useless, BUT it should handle a lot of stuff
libata won't, such as bay batteries, bay floppies, and anything else in
a bay that is not a hard disk.

The fact that the driver currently looks only after disks is just a bug.
It should, in fact, bind to any ejectable device not already handled by
a different driver.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
