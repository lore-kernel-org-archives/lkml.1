Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbYKNATs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbYKNATs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 19:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbYKNATi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 19:19:38 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:26340 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbYKNATh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 19:19:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=v11TqnUnvswPkFENvKIbgO0Ki5GIyu3MzPzCRRvHQGDZbHbnPDbBeThIV/MKWbIWAb
         sCC0bpZeJEnh1Sy1k6Dzv2EkARW0ITb7wYbzLKbAfQ7LmjfcTTTsgVaF54yYrhP18DRR
         P/Kde9gcV2ABsBPJjj10+8f91YraKzXvLRwxw=
Message-ID: <3aaafc130811131619w3ba48a86u6c6e2af35f149bf1@mail.gmail.com>
Date: Thu, 13 Nov 2008 19:19:36 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Olaf van der Spek" <olafvdspek@gmail.com>
Subject: Re: Unix sockets via TCP on localhost: is TCP slower?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <b2cc26e40811121520k711fa702u85e53bbc18b021a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b2cc26e40811121520k711fa702u85e53bbc18b021a0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 6:20 PM, Olaf van der Spek <olafvdspek@gmail.com> wrote:
> Hi,
>
> Quite often in discussions, I see people claiming Unix sockets are
> faster then TCP sockets on a connection that stays inside localhost.

Unix domain sockets should be faster because they're not subject to
windowing, ACKs, flow control, encapsulation, etc. etc.

> Let's say from app A to app B.
> Is this indeed the case and if so, how much and why?
> My assumption is that the kernel can optimize the 'connection' and let
> any performance differences disappear.
>
> Greetings,
>
> Olaf
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
