Return-Path: <linux-kernel-owner+w=401wt.eu-S937459AbYEBXVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937459AbYEBXVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935219AbYEBXVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:21:08 -0400
Received: from mail0.lsil.com ([147.145.40.20]:56035 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764948AbYEBXVF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:21:05 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: HELP:  Is writeq an atomic operation??
Date: Fri, 2 May 2008 17:20:58 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E822901047B4C@NAMAIL2.ad.lsil.com>
In-Reply-To: <adaskx02tr3.fsf@cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: HELP:  Is writeq an atomic operation??
thread-index: AcisqNC7cKzSpJcOQniybIW3bFJmXQAAgjpw
From: "Moore, Eric" <Eric.Moore@lsi.com>
To: "Roland Dreier" <rdreier@cisco.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 May 2008 23:20:59.0336 (UTC) FILETIME=[2E210480:01C8ACAB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> to me.  Does the "Mem MWr(32)" worry you?  I can't see why it 
> would be a
> problem -- the PCIe TLP only has one type of memory write transaction

The concern was raised in a code review we had earlier; it sounds like
we are good.

Under platforms where writeq is not defined, what should I do?

