Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbZGUV42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbZGUV42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbZGUV42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:56:28 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:55913 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155AbZGUV41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:56:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=q6iqWlYIez4YxG0u6k78d5GVuqapBVOern+txIipn/z5fx2wH095tcym9hPbTlbjvt
         PDGNv1bRqspVVnmuC4vEfftmM+DXkE3frJP7z0lQEiCQ2PKbprZjP1QROgQB7eBw2Pef
         T3pQgm/cpLhcUJM/xhUQLIkK5SFpMzi4rdJRM=
Message-ID: <4A663987.4040500@gmail.com>
Date: Tue, 21 Jul 2009 23:56:23 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: Do cpu-endian MMIO accessors exist?
References: <20090721234243.1928d9e2@daedalus.pq.iki.fi> <4A662C33.7080505@gmail.com> <200907212315.50225.arnd@arndb.de>
In-Reply-To: <200907212315.50225.arnd@arndb.de>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2009 11:15 PM, Arnd Bergmann wrote:
> __raw_readl is not a replacement for real accessors like
> ioread32 or in_be32, because it does not synchronize with the
> instruction stream.

Aha, I see now. I guess it's a bug that ioread/write* on sh are not with
barriers?
