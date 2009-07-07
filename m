Return-Path: <linux-kernel-owner+w=401wt.eu-S1752058AbZGGFDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbZGGFDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 01:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbZGGFDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 01:03:25 -0400
Received: from ozlabs.org ([203.10.76.45]:43178 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbZGGFDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 01:03:24 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Subject: Re: [PATCH] kernel: allow whitespace as kernel parameter separator
Date: Tue, 7 Jul 2009 14:33:25 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4A52141A.8020709@linux.vnet.ibm.com>
In-Reply-To: <4A52141A.8020709@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907071433.25406.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009 12:41:22 am Peter Oberparleiter wrote:
> From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
>
> Some boot mechanisms require that kernel parameters are stored in a
> separate file which is loaded to memory without further processing
> (e.g. the "Load from FTP" method on s390). When such a file contains
> newline characters, the kernel parameter preceding the newline might
> not be correctly parsed (due to the newline being stuck to the end of
> the actual parameter value) which can lead to boot failures.
>
> This patch improves kernel command line usability in such a situation
> by allowing generic whitespace characters as separators between kernel
> parameters.

Makes sense, applied.

Thanks!
Rusty.
