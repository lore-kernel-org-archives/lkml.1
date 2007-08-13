Return-Path: <linux-kernel-owner+w=401wt.eu-S947281AbXHMQQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S947281AbXHMQQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S947330AbXHMPBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:01:11 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:4362 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937830AbXHMPBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:01:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=n8lbPQBKcCYfBEdmtCI/oTKv6jrHus3qxjh1aAyrePwOiBWIPgGtvdgDTEzSLS6wyOXDNd2CZsOEFeUADz0/v1Xm8PccPfswjpJJY2egZjVyJz1E3IvHq1RVknQOJ057mHSbR2pLXdKgiAbeBwGnuHIFjPdN1GlwVwsB0uAfQIU=
Message-ID: <9a8748490708130801o682d1be4je076bcd7a0682def@mail.gmail.com>
Date: Mon, 13 Aug 2007 17:01:05 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: James.Smart@emulex.com
Subject: Re: [PATCH 4/6][RESEND] Emulex FC HBA driver: fix overflow of statically allocated array
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org,
       "James Bottomley" <James.Bottomley@steeleye.com>
In-Reply-To: <46C0584E.5060906@emulex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708130016.11281.jesper.juhl@gmail.com>
	 <200708130021.07068.jesper.juhl@gmail.com>
	 <46C038E3.5090204@emulex.com>
	 <9a8748490708130415j790d6e49y6ae12ca8dad780f2@mail.gmail.com>
	 <46C0584E.5060906@emulex.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/07, James Smart <James.Smart@emulex.com> wrote:
> Ok.... here's what happened,
>
> - We changed the define so that it matched what we are using. We never configure
>    more than 4 HBQ, thus the index will never be beyond 0-3. The if-check is actually
>    innoculous. Given that the change wasn't your patch, we didn't include you as
>    the author.
>
And that's not a problem. I only mentioned it to explain how I
searched for the patch before I resend it.

> - Coding-wise, you are right, we still didn't fix the range check.
>
> Since this really is just something to keep the tools happy - I'll recind the NACK.
> I'll worry about simply removing this if-check later...
>
> James/Andrew, accept this patch - ACK.
>


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
