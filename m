Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbXFLMkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbXFLMkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 08:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbXFLMkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 08:40:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:40633 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933AbXFLMkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 08:40:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=J+4uKFFtHHxxg4KIJ/QD+puYeR72miDA9aEcRBDBs6hnZu9d+8KURvlDydL3+cfazkAaKMDpYBH+0MbmhIWb8ONwAwwUDd9Exjio+Dm37UqdqAKEm2LiXZGUzf4FDnWUZr+FDo200wd0AFekIGHMVAUH1ovuY0ROQ/BJIJ8nfyY=
Message-ID: <9a8748490706120540p29d00d3cg9d8a4def0d57b783@mail.gmail.com>
Date: Tue, 12 Jun 2007 14:40:06 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [-mm patch] #if 0 mm/backing-dev.c:congestion_wait_interruptible()
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070612110733.GU3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070612110733.GU3588@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/07, Adrian Bunk <bunk@stusta.de> wrote:
> congestion_wait_interruptible() is no longer used.
>
Remind me again why it is that we add all these  #if 0  blocks instead
of simply removing the unused code?

It's just creating a janitorial task to go and remove all the #if 0
bits at a later time, seems like pointless churn to me. If the code
needs to go, let's just get rid of it in one go instead of two.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
