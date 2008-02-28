Return-Path: <linux-kernel-owner+w=401wt.eu-S1760368AbYB1Ssg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368AbYB1Ssg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 13:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbYB1Ss2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 13:48:28 -0500
Received: from alpha.facton.com ([83.236.152.122]:57418 "EHLO alpha.facton.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbYB1Ss2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 13:48:28 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Re: zlib oops with ipcomp in 2.6.24
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Thu, 28 Feb 2008 19:47:43 +0100
Message-ID: <3C59DB883F7B0B4D8096010D45ACCD134F2143@exch.facton.local>
In-Reply-To: <20080228175011.GA17185@gondor.apana.org.au>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: zlib oops with ipcomp in 2.6.24
Thread-Index: Ach6MmVrnwAGsZ7uTu2NlT5hQ+iGSQAB4Qcg
References: <3C59DB883F7B0B4D8096010D45ACCD134F210D@exch.facton.local> <20080223000328.3a71e858.akpm@linux-foundation.org> <3C59DB883F7B0B4D8096010D45ACCD134F2112@exch.facton.local> <20080228175011.GA17185@gondor.apana.org.au>
From: "Beschorner Daniel" <Daniel.Beschorner@facton.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "Richard Purdie" <rpurdie@rpsys.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK I've finally found the bug which I must've been subconsciously
> ignoring :)
>
> [IPCOMP]: Disable BH on output when using shared tfm

Thank you, it took 4 weeks and 50 oopses to kill the beast :-)
First tests are looking fine.

Daniel
