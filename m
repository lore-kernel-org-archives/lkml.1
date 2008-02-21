Return-Path: <linux-kernel-owner+w=401wt.eu-S1760998AbYBUGym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760998AbYBUGym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 01:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbYBUGyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 01:54:31 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:15250 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbYBUGya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 01:54:30 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [git patches] net driver updates
Date: Wed, 20 Feb 2008 22:54:15 -0800
Message-ID: <8A71B368A89016469F72CD08050AD334026D652F@maui.asicdesigners.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [git patches] net driver updates
Thread-Index: Ach0UP/jargGiv6QTxqFAjhmOwZ7GwABRPIQ
References: <OF5F5F5698.07AB615F-ON652573F6.00142D8A-652573F6.00147DC9@in.ibm.com><20080220.214651.235108740.davem@davemloft.net><8A71B368A89016469F72CD08050AD334026D6511@maui.asicdesigners.com> <20080220.221554.128587906.davem@davemloft.net>
From: "Divy Le Ray" <divy@chelsio.com>
To: "David Miller" <davem@davemloft.net>
Cc: <krkumar2@in.ibm.com>, <jeff@garzik.org>, <linux-kernel@vger.kernel.org>,
       <netdev@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: "Divy Le Ray" <divy@chelsio.com>
> Date: Wed, 20 Feb 2008 21:57:08 -0800
> 
> > The driver is cxgb3 here, it uses LLTX.
> 
> That's extremely unfortunate, hopefully you can update it to
> use a model like tg3 and others use.  LLTX is a lost cause
> for hardware device drivers, and in fact we'd like to remove
> it tree wide eventually.

It sounds like I messed up.
cxgb3 does not use LLTX - The Chelsio driver does, thus should be
converted.

Divy
