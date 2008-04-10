Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbYDJNPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbYDJNPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 09:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbYDJNPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 09:15:44 -0400
Received: from co300216-co-outbound.net.avaya.com ([198.152.13.100]:24305 "EHLO
	co300216-co-outbound.avaya.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755305AbYDJNPn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 09:15:43 -0400
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Apr 2008 09:15:43 EDT
X-IronPort-AV: E=Sophos;i="4.25,635,1199682000"; 
   d="scan'208";a="117105944"
X-IronPort-AV: E=Sophos;i="4.25,635,1199682000"; 
   d="scan'208";a="180341493"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Kernel Oops on hot insertion of USB
Date: Thu, 10 Apr 2008 15:06:05 +0200
Message-ID: <11486DD9B957EA488E21C44BC8737EFC987F23@307622ANEX5.global.avaya.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Kernel Oops on hot insertion of USB
Thread-Index: AcibC6KN6rAzd6tkQsyPVCaDVIdXWQ==
From: "Rachmel, Nir (Nir)" <rachmel@avaya.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

	I am running linux kernel version 2.6.14.7, and have a problem
when
	inserting / removing a disk-on-key device from my system: I get
a
	"kernel oops". Using some debugging tools I managed to trace the
	problem down to an event of "double free" that occurs within the
hot
	insertion module.
	
	googling didn't help much. Is this a known issue which is
resolved in
	later kernel versions?
	
	
Thanks in advance,

- Nir.
