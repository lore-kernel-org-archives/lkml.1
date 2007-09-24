Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbXIXNAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbXIXNAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757892AbXIXNAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:00:39 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57242 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559AbXIXNAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:00:38 -0400
Message-ID: <46F7B4F2.1040506@fr.ibm.com>
Date: Mon, 24 Sep 2007 15:00:34 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: 2.6.23-rc7-mm1
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
In-Reply-To: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/

I also get this compile error on s390. 'linux/scatterlist.h' has disappeared 
from the #include pile but where ? 

/home/clg/linux/2.6.23-rc7-mm1/net/sctp/auth.c: In function `sctp_auth_calculate_hmac':
/home/clg/linux/2.6.23-rc7-mm1/net/sctp/auth.c:695: error: storage size of 'sg' isn't known
/home/clg/linux/2.6.23-rc7-mm1/net/sctp/auth.c:695: warning: unused variable `sg'

Cheers,

C.
