Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbXFMUsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbXFMUsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 16:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbXFMUsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 16:48:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39702 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbXFMUsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 16:48:07 -0400
Message-ID: <46705803.4000901@garzik.org>
Date: Wed, 13 Jun 2007 16:48:03 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Subject: Re: [patch 2a/3] Expose Power Management Policy option to users
References: <20070611184146.448266229@intel.com>	 <20070611114820.5290a903.kristen.c.accardi@intel.com>	 <466DA9DD.8080004@garzik.org>	 <20070612104631.44dab4a3.kristen.c.accardi@intel.com> <1181748408.3421.7.camel@mulgrave.il.steeleye.com>
In-Reply-To: <1181748408.3421.7.camel@mulgrave.il.steeleye.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> To take the model I understand: SAS; the links are managed at the phy
> level, so the power policy should be set there and thus should probably
> be a property of the phy object, which doesn't even exist in the SCSI
> model, it only exists in the transport class.  It strikes me that even
> for ATA, the same thing is probably true.
> 
> Now, I can see that the power management models of all the transports
> might share some similarities (particularly at this three stage granular
> level); if so, it might make sense to export helpers from the mid-layer
> for the transport classes to use for this.


Agreed, in principle.

	Jeff


