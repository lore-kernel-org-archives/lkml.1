Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbZD1CHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbZD1CHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 22:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759796AbZD1CHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 22:07:15 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:58805 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080AbZD1CHO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 22:07:14 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] fsldma: use PCI Read Multiple command
Date: Tue, 28 Apr 2009 10:06:58 +0800
Message-ID: <D7CCA83BB0796C49BC0BB53B6AB1208928CACB@zch01exm21.fsl.freescale.net>
In-Reply-To: <49F60F1C.3050300@ovro.caltech.edu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fsldma: use PCI Read Multiple command
Thread-Index: AcnHcwv0CXgr1RsVT8aA0l10yM59VQAMpYSw
References: <20090424183517.GB23140@ovro.caltech.edu>	<D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net>	<ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com>	<49F608B7.9080409@ovro.caltech.edu>	<49F60A3A.4060402@freescale.com>	<49F60BF8.8040404@ovro.caltech.edu> <46B638E2-885C-4281-81EA-CB685264E143@kernel.crashing.org> <49F60EC9.2050501@ovro.caltech.edu> <49F60F1C.3050300@ovro.caltech.edu>
From: "Liu Dave-R63238" <DaveLiu@freescale.com>
To: "David Hawkins" <dwh@ovro.caltech.edu>,
       "Kumar Gala" <galak@kernel.crashing.org>
Cc: "Ira Snyder" <iws@ovro.caltech.edu>, <linux-kernel@vger.kernel.org>,
       <linuxppc-dev@ozlabs.org>, "Dan Williams" <dan.j.williams@intel.com>,
       "Tabi Timur-B04825" <timur@freescale.com>
X-Brightmail-Tracker: AAAAAQAAAWE=
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> You can mark the pci inbound window on the 83xx as 
> >> non-prefetchable(assuming 83xx is host). On a x86 host
> >> I doubt there is any easy way to get non-prefetchable memory.

> One more note; we don't have access to a host-mode MPC8349EA,
> our boards are all targets.

Actually we also can use the inbound window(w/wo prefetchable)
in the agent mode. It doesn't care if it is host or agent.
