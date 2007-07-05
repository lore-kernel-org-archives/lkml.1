Return-Path: <linux-kernel-owner+w=401wt.eu-S1762663AbXGEXxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762663AbXGEXxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759896AbXGEXxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:53:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:52664 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759802AbXGEXxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:53:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=E96zVMd+72hfn9aFDmmnAFsvbR2f7L0BkcxD6K6rfz5rBdVQu4rCvIjJkuv1bBxA5oM8Buo5LqMRrC8jFP2Q1/ndlVKhtUDkvrpZHDNyUzIQBKL998Fo+mM4DiAPBppBRIYmgMZVFGxf8nLjR2cdtzbVMTNPvDA+piJLOeJCwxw=
Message-ID: <9a8748490707051653q6e1b6bf3g9a3d6edf213867d9@mail.gmail.com>
Date: Fri, 6 Jul 2007 01:53:07 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: Understanding I/O behaviour
Cc: knobi@knobisoft.de, linux-kernel@vger.kernel.org
In-Reply-To: <468D832B.4060002@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.gAvf+r9fiPwNwNVqahYy5u1/Is0@ifi.uio.no>
	 <468D832B.4060002@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/07, Robert Hancock <hancockr@shaw.ca> wrote:
[snip]
>
> Try playing with reducing /proc/sys/vm/dirty_ratio and see how that
> helps. This workload will fill up memory with dirty data very quickly,
> and it seems like system responsiveness often goes down the toilet when
> this happens and the system is going crazy trying to write it all out.
>

Perhaps trying out a different elevator would also be worthwhile.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
