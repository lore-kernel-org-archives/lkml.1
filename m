Return-Path: <linux-kernel-owner+w=401wt.eu-S1757617Ab0ANUVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab0ANUVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 15:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757592Ab0ANUVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 15:21:46 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39697 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753312Ab0ANUVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 15:21:44 -0500
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jan 2010 15:21:44 EST
X-Sasl-enc: 4Zq7DpCYf/eOOOXLwZg0kP+flZ/6uWxZZt1qJomptxrs 1263499899
Date: Thu, 14 Jan 2010 18:11:36 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Seth Heasley <seth.heasley@intel.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.32.3] ahci: AHCI and RAID mode SATA patch for Intel
 Cougar Point DeviceIDs
Message-ID: <20100114201136.GA3814@khazad-dum.debian.net>
References: <201001121700.18234.seth.heasley@intel.com>
 <4B4D4EAA.2010109@gmail.com>
 <4B4DAA68.60608@pobox.com>
 <51f3faa71001131611y343ad225n1acc73900fd49894@mail.gmail.com>
 <51f3faa71001131642u2cc9de80n8e73be7a8707afb2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51f3faa71001131642u2cc9de80n8e73be7a8707afb2@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010, Robert Hancock wrote:
> Hmm, it seems like it's a bit more complicated than that. For ICH6R
> (0x2652), ata_piix attaches to it regardless of mode intentionally, it
> has specific logic to disable AHCI on the controller since it can be
> used in either mode. That seems a bit questionable. Having the same
> device being handled by different enabled drivers and depending on
> link or module load order to decide which one loads is fragile and
> prone to errors. I'd be in favor of removing the ICH6R support from
> ata_piix entirely and saying that you should be using ahci for that
> device. Maybe when ahci was immature there was a benefit to allowing
> ata_piix to run it, but I doubt that's true today.

Maybe it is the silicon AHCI in ICH6R that is immature, and one is much
better of using it in IDE mode?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
