Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbXEAQE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbXEAQE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbXEAQE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:04:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:56038 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753182AbXEAQEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:04:25 -0400
X-Authenticated: #476490
X-Provags-ID: V01U2FsdGVkX19MmiRwHf1MTkTYdXK4lG07Nzdv8fTYYKXNtHT6q/
	73T3FI9/cuNfDJ
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: v4l-dvb-maintainer@linuxtv.org
Organization: ESCAPE GmbH EDV-Loesungen
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Re: More than 2Gb problem (dvb related) ?
Date: Tue, 1 May 2007 17:58:42 +0200
User-Agent: KMail/1.9.4
Cc: Jon Burgess <jburgess777@googlemail.com>, v4l-dvb-maintainer@linuxtv.org,
       Lee Revell <rlrevell@joe-job.com>,
       Gregoire Favre <Gregoire.Favre@gmail.com>, linux-kernel@vger.kernel.org
References: <20070427111047.GB10284@gmail.com> <75b66ecd0704271506x595dfb6bqe0ef4fd153818501@mail.gmail.com> <1177780652.7152.14.camel@localhost.localdomain>
In-Reply-To: <1177780652.7152.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705011758.42921@orion.escape-edv.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Burgess wrote:
> It appears the problem is that the driver is using streamed PCI and
> needs to explicitly sync the data otherwise it breaks when the SWIOTLB
> is in use. A call to pci_unmap_sg() was missing too.
> 
> This patch is against the current v4l-dvb HG tree.
> 
> I've only tested the change with a budget-ci card.

Has anyone a problem with this patch?
If not I'll apply it tomorrow...

Oliver

-- 
--------------------------------------------------------
VDR Remote Plugin 0.3.9 available at
http://www.escape-edv.de/endriss/vdr/
--------------------------------------------------------

