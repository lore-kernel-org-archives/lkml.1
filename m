Return-Path: <linux-kernel-owner+w=401wt.eu-S932164AbYCDRDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbYCDRDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760729AbYCDRDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:03:16 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:23371 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760585AbYCDRDP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:03:15 -0500
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ISS StorageDev <iss_storagedev@hp.com>
Date: Tue, 4 Mar 2008 17:02:29 +0000
Subject: RE: 2.6.25-rc3-mm1 (CCISS)
Thread-Topic: 2.6.25-rc3-mm1 (CCISS)
Thread-Index: Ach+F2jABaRmw31ESuaQSNHV2pF+rQAAauog
Message-ID: <DEE40752C8AF224BB890E455C7B8E0FE042B764935@G6W0268.americas.hpqcorp.net>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
 <20080304084557.357972a3.randy.dunlap@oracle.com>
In-Reply-To: <20080304084557.357972a3.randy.dunlap@oracle.com>
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

Randy wrote:
>
> On Tue, 4 Mar 2008 01:19:28 -0800 Andrew Morton wrote:
>
> >
> >
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-r
> > c3/2.6.25-rc3-mm1/
>
> With
> CONFIG_BLK_CPQ_DA=m
> CONFIG_BLK_CPQ_CISS_DA=m
> # CONFIG_CISS_SCSI_TAPE is not set
>
> I'm getting
> In file included from drivers/block/cciss.c:230:
> drivers/block/cciss_scsi.c:1498:38: error: macro parameters
> must be comma-separated
> drivers/block/cciss.c: In function 'cciss_seq_show_header':
> drivers/block/cciss.c:271: error: implicit declaration of
> function 'cciss_seq_tape_report'
> drivers/block/cciss.c: In function 'cciss_proc_write':
> drivers/block/cciss.c:392: error: implicit declaration of
> function 'cciss_engage_scsi'
> make[2]: *** [drivers/block/cciss.o] Error 1
> make[1]: *** [drivers/block] Error 2
> make[1]: *** Waiting for unfinished jobs....
>
> ---
Randy,
It looks like you have the original broken patch. I resubmitted and I think Jens picked up the fixed patch but I don't know where it is...  :(

-- mikem
