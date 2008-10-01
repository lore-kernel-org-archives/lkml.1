Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbYJAUSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbYJAUSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 16:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbYJAUSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 16:18:13 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:3087 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbYJAUSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 16:18:12 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/2] PNP: don't check disabled PCI BARs for conflicts in quirk_system_pci_resources()
Date: Wed, 1 Oct 2008 14:18:06 -0600
User-Agent: KMail/1.9.9
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org, Adam Belay <abelay@mit.edu>,
       Avuton Olrich <avuton@gmail.com>,
       Karl Bellve <karl.bellve@umassmed.edu>, Willem Riede <wriede@riede.org>,
       Matthew Hall <mhall@mhcomputing.net>
References: <200809290953.56565.bjorn.helgaas@hp.com> <alpine.LFD.2.00.0809300904530.3389@nehalem.linux-foundation.org> <200809301312.50712.bjorn.helgaas@hp.com>
In-Reply-To: <200809301312.50712.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810011418.06908.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Where are we on this regression?  We got side-tracked with all
the initcall ordering stuff, but I don't think that leads to
something appropriate for this late stage of 2.6.27.

I think the safest (and already tested) path is the
"res->start == 0 means disabled" check in the PNP quirk.

Bjorn
