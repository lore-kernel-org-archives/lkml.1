Return-Path: <linux-kernel-owner+w=401wt.eu-S1764047AbXLUD1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764047AbXLUD1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 22:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbXLUD0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 22:26:51 -0500
Received: from ozlabs.org ([203.10.76.45]:57871 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbXLUD0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 22:26:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/5] sg_ring for scsi
Date: Fri, 21 Dec 2007 14:26:47 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: davem@davemloft.net, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com, dougg@torque.net
References: <200712201853.48643.rusty@rustcorp.com.au> <200712211013.38511.rusty@rustcorp.com.au> <20071221112834X.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20071221112834X.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712211426.47896.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 December 2007 13:28:34 FUJITA Tomonori wrote:
> I'm not sure about chaining the headers (as your sg_ring and
> scsi_sgtable do) would simplify LLDs. Have you looked at ips or
> qla1280?

Not yet, am working my way through the drivers, but I don't expect it will be 
a simplification to the normal SCSI LLDs.  Most of them are mere consumers of
sgs...

I'm not a SCSI person: I'm patching SCSI because I have to to get my own 
sg-using code clean :)

Hope that clarifies,
Rusty.
