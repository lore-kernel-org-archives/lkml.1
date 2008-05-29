Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbYE2Rva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbYE2Rva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 13:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbYE2RvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 13:51:20 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45582 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341AbYE2RvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 13:51:19 -0400
X-Sasl-enc: QTkGjM6S6rk0H+75S4Q/FYA39C58aODSlZe+UXN9tqcl 1212083477
Date: Thu, 29 May 2008 14:51:16 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] libata: Handle bay devices in dock stations
Message-ID: <20080529175116.GE3375@khazad-dum.debian.net>
References: <20080528143857.GB5585@homac.suse.de> <20080529132253.GA22309@srcf.ucam.org> <483EB33D.6010101@gmail.com> <20080529140213.GA23373@srcf.ucam.org> <20080529141421.GC9268@homac.suse.de> <20080529143541.GA24013@srcf.ucam.org> <483EBFC5.7020406@gmail.com> <20080529144934.GA24382@srcf.ucam.org> <20080529163201.GA4520@homac>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080529163201.GA4520@homac>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Holger Macht wrote:
> On Thu 29. May - 15:49:34, Matthew Garrett wrote:
> > Got it. It works if I lose the ata_port_freeze() from 
> > ata_acpi_detach_device. 
> 
> Tejun, any idea? This is in for quite some time now. Maybe there's some
> involved...

<naivë question> Do we handle the possible fact that _EJ0 might want the
port (and maybe the device) to be active when it is called AND that _EJ0
might attempt to shutdown the port or the device itself?  </naivë
question>

Please ignore if it is something not even worth answering.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
