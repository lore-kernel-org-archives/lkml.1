Return-Path: <linux-kernel-owner+w=401wt.eu-S1759649AbXHTOi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759649AbXHTOi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 10:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbXHTOiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 10:38:46 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:56402 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbXHTOip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 10:38:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fb/KDyQ4x/98QEyDX0Z/ZexY/vwHkHEXAvSMPvZNSKScIm+U9RaS51X6j+Wi/sLJoMmcjLh5HNIazlE/jcsbR727onbaNRL7rKDKR6a52WUbtvWyoWcgYiRBRv0CdmpT2aWuCHQfWwQ2Wgv/yvnM8WDuUSADtcBJu5HD7CVA7qQ=
Message-ID: <9a8748490708200738o36374d63ib5c71d5dc8dc9978@mail.gmail.com>
Date: Mon, 20 Aug 2007 16:38:41 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Anand Jahagirdar" <anandjigar@gmail.com>
Subject: Re: Fork Bombing Patch
Cc: "Krzysztof Halasa" <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
In-Reply-To: <25ae38200708200726tdf097b1kcd0269cf11c53bf3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com>
	 <m3lkcbu3ps.fsf@maximus.localdomain>
	 <25ae38200708200726tdf097b1kcd0269cf11c53bf3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(please don't top-post)

On 20/08/07, Anand Jahagirdar <anandjigar@gmail.com> wrote:
> Hi
>   I think Its not worth to make it configurable just for one printk
> statement. am i missing something?
>

I think you are missing the fact that there are lots of situations
where users may hit the configured process limit without that being an
indication of a fork bomb (or other) attack.
This means that there will be many systems that will trigger your
warning where there really is no problem. That's a good reason for a)
making the message KERN_INFO and b) let administrators somehow disable
it completely.

Personally I'm wondering if we even want/need this at all.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
