Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbYJNPwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbYJNPwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 11:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYJNPwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 11:52:01 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:36426 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYJNPwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 11:52:00 -0400
Date: Tue, 14 Oct 2008 09:51:43 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: Distributed storage release.
In-reply-to: <20081013133850.GA13565@2ka.mipt.ru>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Message-id: <20081014155143.GM2009@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <20081006160034.GA611@2ka.mipt.ru>
 <20081012192419.fd8394c9.akpm@linux-foundation.org>
 <20081013133850.GA13565@2ka.mipt.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 13, 2008  17:38 +0400, Evgeniy Polyakov wrote:
> There are two types of errors: long lines, which are actually comments
> on the same line as structure members or a little bit more than 80;
> and things like spaces and braces. All other errors should be already
> fixed, but stuff like this: for (i = 0; i < 10; ++i) are not, since we
> can argue forever if this is better than for (i=0; i<10; ++i) or 
> int (* iterator) (struct dst_crypto_engine *e, vs
> int (*iterator) (struct dst_crypto_engine *e,
> :)
> Also braces on the same line with the structure definition does not look
> good imho, and it is reported as error by checkpatch.

While it is true that one coding style vs. another could be argued for
a long time - the right answer is that the _right_ coding style for code
added to the Linux kernel is Linus' CodingStyle document.

Whether you think the braces here or there look better - consistency
with other code in the same project is very important, and any changes
you get to your code will come in the Linus CodingStyle and this will
result in code that is a mix between your personal style and the official
style and it will be a mess...

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

