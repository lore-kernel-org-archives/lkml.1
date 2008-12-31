Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbYLaGv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbYLaGv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 01:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYLaGvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 01:51:18 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:35174 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbYLaGvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 01:51:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=i8KWzPVanwwwobXAfptB2WG2JnrpsM3vRHPPIWax30BEJdEbEOH5NWsD+YhY4I71u8
         2H+vneeXChUkQYL4U7GhhSkXNaOSj+M7kRcE2gc+X6wefYxGFW3idrhC22VoQaYSQFkS
         wXfbf85MsxuaqzK9ByzBUVWDQQno2XJ1g1oo8=
Message-ID: <b681c62b0812302251p195debf5v360e1058de5c18e1@mail.gmail.com>
Date: Wed, 31 Dec 2008 12:21:16 +0530
From: "yogeshwar sonawane" <yogyas@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: PCI resource collision message
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have seen the following message in /var/log/messages file :-

PCI: Device 0000:01:00.0 not available because of resource collisions

Whenever this msg comes, the PCI card which is present in 0000:01:00.0
is not useful/accessible.
While detection of card, pci_set_master() fails.
But after reboot, that msg goes & card is working fine.

This card is a Network controller PCI-Express based card.
The above problem comes very rarely & not on all the test nodes. The
situation may be difficult to reproduce.

So, my question is, what to interpret from the above message ?
PCI bios allocates the PCI resources. So where to look to remove this error ?

TIA,
Yogeshwar
