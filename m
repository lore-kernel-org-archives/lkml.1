Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbYFYEJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbYFYEJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbYFYEJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:09:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:64083 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbYFYEJR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:09:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,700,1204531200"; 
   d="scan'208";a="299264727"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Scatter-gather list constraints
Date: Tue, 24 Jun 2008 21:02:58 -0700
Message-ID: <C72DEB015BA7724783363DE1AF6B0F980510BAC2@orsmsx417.amr.corp.intel.com>
In-Reply-To: <485FF44C.4010600@csr.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Scatter-gather list constraints
Thread-Index: AcjVZFzFh/uLDhugQKOUtnxCR2wiMQBE9j/g
References: <Pine.LNX.4.44L0.0806231109280.2556-100000@iolanthe.rowland.org> <485FF44C.4010600@csr.com>
From: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
To: "David Vrabel" <david.vrabel@csr.com>,
       "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Kernel development list" <linux-kernel@vger.kernel.org>,
       "AntonioLin" <antonio.lin@alcormicro.com>, <linux-usb@vger.kernel.org>
X-OriginalArrivalTime: 25 Jun 2008 04:09:16.0679 (UTC) FILETIME=[3C0AD970:01C8D679]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: David Vrabel [mailto:david.vrabel@csr.com]
>
>> That would be ideal.  However there is no way to pass an S-G list
along
>> with an URB; there's no field for it in the data structure.  And none
>> of the existing host controller drivers support such a thing.
>>
>> I suppose we could add a field to struct urb and add a flag
indicating
>> whether the controller driver supports S-G lists.
>
>This is what I was thinking.

That would simplify a *LOT* of WUSB wire-adapter code which now is a
horrible kludge.

-- Inaky

