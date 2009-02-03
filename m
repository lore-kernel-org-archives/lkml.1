Return-Path: <linux-kernel-owner+w=401wt.eu-S1755591AbZBCSVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbZBCSVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 13:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbZBCSVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 13:21:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46841 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbZBCSV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 13:21:29 -0500
Date: Tue, 3 Feb 2009 19:21:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       jejb <James.Bottomley@steeleye.com>, scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH mm/next] libfc: uses/select CRC32
Message-ID: <20090203182110.GA24821@elte.hu>
References: <200901052050.n05Kox9j012519@imap1.linux-foundation.org> <4962A04F.5020404@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4962A04F.5020404@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> libfc uses crc32 functions, so cause it to be built
> via select:
> 
> drivers/built-in.o: In function `fc_frame_crc_check':
> (.text+0x75dae): undefined reference to `crc32_le'
> drivers/built-in.o: In function `fc_fcp_recv':
> fc_fcp.c:(.text+0x7b919): undefined reference to `crc32_le'
> fc_fcp.c:(.text+0x7b9d5): undefined reference to `crc32_le'
> fc_fcp.c:(.text+0x7ba54): undefined reference to `crc32_le'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Hm, is there a reason why this fix has not gone upstream? I'm still 
stumbling across it in build tests with a latest -git base.

	Ingo
