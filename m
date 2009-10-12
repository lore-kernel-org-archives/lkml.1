Return-Path: <linux-kernel-owner+w=401wt.eu-S933184AbZJLXnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184AbZJLXnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 19:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932721AbZJLXnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 19:43:31 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:43736 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695AbZJLXnb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 19:43:31 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: Hank Janssen <hjanssen@microsoft.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tom Hanrahan <hanrahat@microsoft.com>,
       "Hashir Abdi" <habdi@microsoft.com>
Subject: RE: [patch] Staging: hv: Fix vmbus load hang caused by wrong data
 packing
Thread-Topic: [patch] Staging: hv: Fix vmbus load hang caused by wrong data
 packing
Thread-Index: AcpJ/6FE0xhfIRwfRT+rZ9QOhF0ebwBi+82AAA3jUSD//7JUgIAAXx2g///RCwCAAHMwwP//nwIAgABQlwA=
Date: Mon, 12 Oct 2009 23:41:59 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7212DF13EE@TK5EX14MBXC130.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF7212DEE3EC@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20091012153013.GA2062@suse.de>
 <1FB5E1D5CA062146B38059374562DF7212DF10DD@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20091012172953.GA10557@suse.de>
 <8AFC7968D54FB448A30D8F38F259C5620E7B1C22@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <20091012202214.GA9631@suse.de>
 <1FB5E1D5CA062146B38059374562DF7212DF127D@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20091012212722.GA22118@suse.de>
In-Reply-To: <20091012212722.GA22118@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We need to find the root cause of _why_ your patch fixes the problem
> here,
> that is what I am trying to get you to do.
OK, I will add some temporary code to get the size and the address of the fields in the data structures. Hope that will help us understand the mechanism of this fix.

Thanks,

- Haiyang


