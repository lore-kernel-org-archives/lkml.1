Return-Path: <linux-kernel-owner+w=401wt.eu-S1757860AbYLPQNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbYLPQNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 11:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbYLPQNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 11:13:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:17542 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbYLPQNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 11:13:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=XGZb2Dxi6e6juo0AZY4zewT35pHB6sgDTIWYXZCZW3AiluwLvkfV2Ta9oQpgoC++Yx
         ZoUetpSp3XgnwSXTclXvcBtOqUvroqyFTWlrdD9+skm/PQyMgktw0rlm5Zt1Jdsa58Yi
         w0x91h9YzGjt8HSurrx+iJyzZHkbbnrTuwvzg=
Message-ID: <84144f020812160813x692abe16t5148462a9036856d@mail.gmail.com>
Date: Tue, 16 Dec 2008 18:13:32 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: ptb@inv.it.uc3m.es
Subject: Re: time_is_after_jiffies misnomer
Cc: hannes@cmpxchg.org, "linux kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <200812161604.mBGG4qT10889@inv.it.uc3m.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200812161604.mBGG4qT10889@inv.it.uc3m.es>
X-Google-Sender-Auth: c288fa9429b2d74a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 6:04 PM, Peter T. Breuer <ptb@inv.it.uc3m.es> wrote:
> The kernel's
>
>     time_is_after_jiffies(500)
>
> macro mathematically means
>
>    the current value of the jiffies variable is LESS THAN 500

Not that you would ever do something like that. Instead, you will see
something like this if you grep the kernel sources a bit:

    time_is_after_jiffies(jiffies + 500)

                    Pekka
