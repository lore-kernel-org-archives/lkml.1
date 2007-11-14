Return-Path: <linux-kernel-owner+w=401wt.eu-S1762347AbXKNUY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762347AbXKNUY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 15:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbXKNUYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 15:24:49 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:17072 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbXKNUYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 15:24:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Rns59A+43IFjnxaw0tRn8n31qYbMovTSdzYSxnowiNXU5oXxElfV1rSdzKvlCh+Bnf+/b9uRfwx6hKi6fM7c+pw7liXUWmKpRgsJajV/W6ieO6kRr4EbSqDU+FRVpGo9rzmnl5Dzd1UEZn2JHVBcmcJUVuSig78Yj3++ksnKZcg=
Message-ID: <473B5987.60904@gmail.com>
Date: Wed, 14 Nov 2007 21:24:39 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: broken suspend [Was: 2.6.24-rc2-mm1]
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
In-Reply-To: <20071113175906.497a1a6a.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2007 02:59 AM, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc2/2.6.24-rc2-mm1/

Doesn't suspend for me (neither broken-out-2007-11-13-04-14 did) on x86_64.
echo mem >/sys/power/state
causes shut down of disk(s) and blinking cursor on 1,1 position.
The last working was 2.6.23-rc8-mm2. I haven't tested
2.6.23-mm1, since it didn't work for me.

As usual, I don't know how to debug this and what other info is needed, any
thoughts?

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
