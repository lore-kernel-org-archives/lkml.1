Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbZCOJb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbZCOJb3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 05:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbZCOJbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 05:31:19 -0400
Received: from mail-bw0-f175.google.com ([209.85.218.175]:48198 "EHLO
	mail-bw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbZCOJbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 05:31:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=B+5nGUNf7HzX/7Hs6PsUpTiyQVW3RRTTmhbgzfd2GP6p8lcDYnbyaETLrWONb2jVvx
         J8mu17V3OgU2g76/k9xYpPs9HeTkgtFYaj0qSUuaaPKNv/QTiJJq1aa+WEjmjYG36w89
         rWEXlLP0EGg3RVKzHawPwO2UEEXa4BX3DnJns=
Message-ID: <49BCCAE0.6010303@gmail.com>
Date: Sun, 15 Mar 2009 10:31:12 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jan Kasprzak <kas@fi.muni.cz>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: MOXA I/O errors on 2.6.28+
References: <20090314213630.GA3375@fi.muni.cz> <20090314214230.352d293e@lxorguk.ukuu.org.uk> <20090314224138.GC3375@fi.muni.cz>
In-Reply-To: <20090314224138.GC3375@fi.muni.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.3.2009 23:41, Jan Kasprzak wrote:
> Alan Cox wrote:
> : Sounds like a refcount bug.
...
> d450b5a0196b6442cf3f29fc611d9c8daa56b559 tty: kref usage for isicom and moxa.

Thanks a heap. moxa_poll_port is a good candidate for fixing. A patch 
will follow, could you try it?
