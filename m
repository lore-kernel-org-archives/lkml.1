Return-Path: <linux-kernel-owner+w=401wt.eu-S1763984AbXJQPVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763984AbXJQPVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 11:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759653AbXJQPVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 11:21:35 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:28999 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677AbXJQPVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 11:21:34 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 4/5] ibmebus: Move to of_device and of_platform_driver, match eHCA and eHEA drivers
Date: Wed, 17 Oct 2007 17:21:07 +0200
User-Agent: KMail/1.9.1
Cc: Jeff Garzik <jeff@garzik.org>, Thomas Q Klein <tklein@de.ibm.com>,
       Jan-Bernd Themann <THEMANN@de.ibm.com>, netdev@vger.kernel.org,
       Paul Mackerras <pmac@au1.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       Christoph Raisch <raisch@de.ibm.com>, Marcus Eder <meder@de.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <OF48E0997F.B61F7220-ONC125736F.002D7F06-C125736F.002DD39C@de.ibm.com> <200710162320.00630.fenkes@de.ibm.com> <20071017012706.adbd3188.sfr@canb.auug.org.au>
In-Reply-To: <20071017012706.adbd3188.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710171721.08565.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2007 17:27, Stephen Rothwell wrote:

> One small change - I intend to remove the name and owner fields from
> struct of_platform_driver, so you should not bother initialising the name
> field and just initialise the name field of the embedded struct
> device_driver instead.  This, of course, means that you don't need
> 
> 	drv->driver.name = drv->name;
> 
> in ibmebus_register_driver.

I'd prefer to let this line stay in place until you actually make your
change, to keep the data structures consistent as long as the name field is
present. You could remove it in your patch then.

Regards,
  Joachim

