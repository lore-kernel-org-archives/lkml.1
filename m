Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab0CJI3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 03:29:40 -0500
Received: from mail-pz0-f200.google.com ([209.85.222.200]:38339 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab0CJI3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 03:29:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=MBfYJWdOVfhJBjpPQXFWm337T1MqGISJhuMNbUnOvmKwq9/Bvo45EOblyRpeClqtmZ
         9SwClecGXhf6Y6tpWbX5rFcQ1omsfB9WwXCbTVGZLS4GLsfSffJaDv04u1OE7gD3bx1U
         5aqWYeUftRrZPA+i01LuqrEbRp03+2evvWRuQ=
MIME-Version: 1.0
Date: Wed, 10 Mar 2010 16:29:37 +0800
Message-ID: <2375c9f91003100029q7d64bbf7xce15eee97f7e2190@mail.gmail.com>
Subject: 2.6.34-rc1: kernel BUG at mm/slab.c:2989!
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, mm experts,

I triggered an mm bug today, the full backtrace is here:

http://pastebin.ca/1831436

I am using yesterday's Linus tree.

It's not easy to reproduce this, I got this very randomly.

Some related config's are:

CONFIG_SLAB=y
CONFIG_SLABINFO=y
# CONFIG_DEBUG_SLAB is not set

Please let me know if you need more info.

Thanks.
