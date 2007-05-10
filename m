Return-Path: <linux-kernel-owner+w=401wt.eu-S1760185AbXEJQUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbXEJQUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 12:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbXEJQU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 12:20:27 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:38443 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbXEJQU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 12:20:26 -0400
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 May 2007 12:20:26 EDT
Message-ID: <464344FD.6000809@cateee.net>
Date: Thu, 10 May 2007 18:14:53 +0200
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] "volatile considered harmful" document
References: <25493.1178744744@lwn.net>
In-Reply-To: <25493.1178744744@lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
> +The volatile storage class was originally meant for memory-mapped I/O
> +registers.  Within the kernel, register accesses, too, should be protected

I don't think it deserves to be added in documentation, but just for
reference: in userspace "volatile" is needed in signals (posix mandates
some variables to be volatile, as API, not as funtionality). I don't
know if this was also on the original signal handling.

Anyway user space APIs are not kernel problem ;-)

ciao
	cate
