Return-Path: <linux-kernel-owner+w=401wt.eu-S935574AbXJQQWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935574AbXJQQWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 12:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761994AbXJQQV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 12:21:56 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.144]:50573 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760852AbXJQQVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 12:21:55 -0400
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <47163697.9020904@avtrex.com>
Date: Wed, 17 Oct 2007 09:21:43 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: veerasena reddy <veerasena_b@yahoo.co.in>
Cc: "linux-kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mips <linux-mips@linux-mips.org>
Subject: Re: Linux-2.6.18.8 compilation errors with GCC-4.2.1 and binutils-2.17
 on MIPS
References: <304090.76321.qm@web8411.mail.in.yahoo.com>
In-Reply-To: <304090.76321.qm@web8411.mail.in.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Oct 2007 16:21:44.0099 (UTC) FILETIME=[CEA5F730:01C810D9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

veerasena reddy wrote:
> Hi,
> 
> I tried to compile Linux-2.6.18.8 for MIPS24KE
> processor using cross-compiler built from gcc-4.2.1,
> binutils-2.17 and uClibc-0.9.27. But, the compilation
> failed with below error message ("mips-linux-ld: final
> link failed: Bad value"):
> ================================

The likely cause is:

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=33755

As indicated in the PR, Richard has a patch that he is testing.  I would 
think that by the time gcc-4.2.3 is released that it would be fixed.

I would recommend using a non-4.2.x version of gcc until the problem is 
fixed.

David Daney

