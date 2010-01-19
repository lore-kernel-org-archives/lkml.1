Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944Ab0AST6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab0AST6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 14:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539Ab0AST6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 14:58:10 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:63768 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab0AST6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 14:58:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Vq6yGnjKQEX+ZUzxriRj0dX1xF6euH1lqn0KGhbZk5/r9Ov1JBLwvtRKGDbTv8Z8Yc
         L0469STUccqWvuyaF17l8zyZw9YiEFqWzp5dlf2ZwYniK2Dtlt78BmhafUhJ7KPxV6dF
         ZiDYenC9BTpfCXTotdS901zmVjUlxfvmcaTVA=
Message-ID: <4B560ECC.4020506@gmail.com>
Date: Tue, 19 Jan 2010 14:58:04 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Linux Kernel Developers <linux-kernel@vger.kernel.org>
CC: Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2] tcp: input header length, prediction, and timestamp
 bugs
References: <4B49C2D0.1070704@gmail.com> <4B50BFFC.8010108@gmail.com> <4B55ED46.40909@gmail.com>
In-Reply-To: <4B55ED46.40909@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Allen Simpson wrote:
> Therefore, I'll resubmit this patch, removing the existing len parameter.
> 
And for record, there's a jtcp_rcv_established(), and the len isn't used
there either (it uses skb->len instead).

I also discovered that the related tcp_rcv_state_process() and
tcp_rcv_synsent_state_process() never uses their len parameter.
So, I'll remove them, too.
