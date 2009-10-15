Return-Path: <linux-kernel-owner+w=401wt.eu-S1763079AbZJOWiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763079AbZJOWiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 18:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbZJOWiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 18:38:04 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:44888 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754451AbZJOWiB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 18:38:01 -0400
From: Shreyas Bhatewara <sbhatewara@vmware.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>
Date: Thu, 15 Oct 2009 15:37:23 -0700
Subject: RE: [PATCH -next] vmxnet3: use dev_dbg, fix build for CONFIG_BLOCK=n
Thread-Topic: [PATCH -next] vmxnet3: use dev_dbg, fix build for
 CONFIG_BLOCK=n
Thread-Index: AcpN5xXSL9nm1bevRVCWduIodoZw0AAANDfg
Message-ID: <89E2752CFA8EC044846EB8499819134101741BA4C0@EXCH-MBX-4.vmware.com>
References: <20091015152538.74a1cb15.sfr@canb.auug.org.au>
 <4AD7A24F.6000900@oracle.com>
In-Reply-To: <4AD7A24F.6000900@oracle.com>
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
> From: Randy Dunlap [mailto:randy.dunlap@oracle.com]
> Sent: Thursday, October 15, 2009 3:30 PM
> To: Stephen Rothwell
> Cc: linux-next@vger.kernel.org; LKML; netdev; David Miller; Shreyas
> Bhatewara; pv-drivers@vmware.com
> Subject: [PATCH -next] vmxnet3: use dev_dbg, fix build for
> CONFIG_BLOCK=n
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> vmxnet3 was using dprintk() for debugging output.  This was
> defined in <linux/dst.h> and was the only thing that was
> used from that header file.  This caused compile errors
> when CONFIG_BLOCK was not enabled due to bio* and BIO*
> uses in the header file, so change this driver to use
> dev_dbg() for debugging output.
> 
> include/linux/dst.h:520: error: dereferencing pointer to incomplete
> type
> include/linux/dst.h:520: error: 'BIO_POOL_BITS' undeclared (first use
> in this function)
> include/linux/dst.h:521: error: dereferencing pointer to incomplete
> type
> include/linux/dst.h:522: error: dereferencing pointer to incomplete
> type
> include/linux/dst.h:525: error: dereferencing pointer to incomplete
> type
> make[4]: *** [drivers/net/vmxnet3/vmxnet3_drv.o] Error 1
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>


Thanks for the changes Randy, appreciate it.

->Shreyas
