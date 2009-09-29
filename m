Return-Path: <linux-kernel-owner+w=401wt.eu-S1752639AbZI2Qh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbZI2Qh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 12:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZI2Qh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 12:37:58 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:34314 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751905AbZI2Qh4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 12:37:56 -0400
From: Shreyas Bhatewara <sbhatewara@vmware.com>
To: David Miller <davem@davemloft.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "shemminger@linux-foundation.org" <shemminger@linux-foundation.org>,
       "jgarzik@pobox.com" <jgarzik@pobox.com>,
       "anthony@codemonkey.ws" <anthony@codemonkey.ws>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>
Date: Tue, 29 Sep 2009 09:37:59 -0700
Subject: RE: [PATCH 2.6.31-rc9] net: VMware virtual Ethernet NIC driver:
 vmxnet3
Thread-Topic: [PATCH 2.6.31-rc9] net: VMware virtual Ethernet NIC driver:
 vmxnet3
Thread-Index: AcpAmO8OkYzDeFS0Te2zUQuqEk0t2QAijigw
Message-ID: <89E2752CFA8EC044846EB849981913410173CDFD23@EXCH-MBX-4.vmware.com>
References: <89E2752CFA8EC044846EB849981913410173CDFAF6@EXCH-MBX-4.vmware.com>
 <20090928.170821.124026517.davem@davemloft.net>
In-Reply-To: <20090928.170821.124026517.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Monday, September 28, 2009 5:08 PM
> To: Shreyas Bhatewara
> Cc: linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
> shemminger@linux-foundation.org; jgarzik@pobox.com;
> anthony@codemonkey.ws; chrisw@sous-sol.org; greg@kroah.com; akpm@linux-
> foundation.org; virtualization@lists.linux-foundation.org; pv-
> drivers@vmware.com
> Subject: Re: [PATCH 2.6.31-rc9] net: VMware virtual Ethernet NIC
> driver: vmxnet3
> 
> From: Shreyas Bhatewara <sbhatewara@vmware.com>
> Date: Mon, 28 Sep 2009 16:56:45 -0700
> 
> > +       uint32_t rxdIdx:12;    /* Index of the RxDesc */
> 
> Don't use uint32_t et al. sized types, use "u32" and friends
> throughout.

Sure, I will fix that.

->Shreyas
