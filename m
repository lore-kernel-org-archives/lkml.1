Return-Path: <linux-kernel-owner+w=401wt.eu-S1758398AbXGWMlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398AbXGWMlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 08:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbXGWMk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 08:40:57 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:45019 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbXGWMk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 08:40:56 -0400
Message-ID: <46A4A16F.7070100@gmail.com>
Date: Mon, 23 Jul 2007 14:39:11 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Jan-Benedict Glaw <jbglaw@lug-owl.de>
CC: Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
       Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFH] Partition table recovery
References: <200707200813.03553.a1426z@gawab.com> <46A24846.7050803@gmail.com> <20070722011141.GJ26752@thunk.org> <200707220710.31402.a1426z@gawab.com> <20070722162802.GA20174@thunk.org> <46A46399.5090406@gmail.com> <20070723084146.GP22998@lug-owl.de> <46A488EB.2050305@gmail.com>
In-Reply-To: <46A488EB.2050305@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2007 12:54 PM, Rene Herman wrote:

> static inline uint32_t le_32(uint32_t n)
> {
> #ifdef __LITTLE_ENDIAN
> 	return n;
> #else
> 	return bswap_32(n);
> #endif
> }

#if __BYTE_ORDER == __LITTLE_ENDIAN, that is. sigh.

Rene.
