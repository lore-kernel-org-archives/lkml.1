Return-Path: <linux-kernel-owner+w=401wt.eu-S1756594AbYE3Knx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbYE3Knx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 06:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYE3Kno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 06:43:44 -0400
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:54413 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbYE3Knn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 06:43:43 -0400
From: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Date: Fri, 30 May 2008 12:43:39 +0200
User-Agent: KMail/1.9.9
Cc: Peer Chen <pchen@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Kuan Luo <kluo@nvidia.com>
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200805291654.03617.volker.armin.hemmann@tu-clausthal.de> <483F804F.1@gmail.com>
In-Reply-To: <483F804F.1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805301243.39751.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Freitag, 30. Mai 2008, Tejun Heo wrote:
> Hello,
>
> Hemmann, Volker Armin wrote:
> > -AHCI+nomsi: boots fine. Works fine. But: I still can not enable ncq
> > -AHCI+msi: the usual. No harddisks found, waiting for the timeouts, then
> > kernel panic because of missing root.
> >
> > -NON-RAID/IDE+msi: works fine. No delays. No NCQ (not surprising since
> > mobos handbook says that AHCI mode is required).
> > -NON-RAID/IDE+nomsi: see above.
>
> So, sans NCQ, the only remaining issue is MSI, right?  Peer Chen, please
> lemme know which controllers are affected by this MSI problem and where
> the problem lies.

this is correct.

> The controller is not reporting NCQ capability in its cap register
> (flags: line contains ncq if the controller is), so NCQ is not enabled.

ah, I thought all AHCI chipsets support NCQ (and the board's handbook lists it 
as feature) thanks for the explanation.

Glück Auf,
Volker
