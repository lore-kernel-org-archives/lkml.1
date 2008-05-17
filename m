Return-Path: <linux-kernel-owner+w=401wt.eu-S1760549AbYEQVJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760549AbYEQVJS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 17:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759280AbYEQVJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 17:09:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:41892 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759125AbYEQVJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 17:09:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WNyMieffGIfsvcEj6Z2YPTYAhz/2nyFI3aGUd+mZcMFX6147t8yLbwifY6OlJz/4nT5CsstF4rDEaPbZYjelo7ubLX3+S6HB4Stk+531SWbr8CWFS60SvMLQNN8b9eS/dlpsiyhDdTOiAex39i4jfpo+ejqs8nldkww4CPg2MoI=
Message-ID: <d4e708d60805171409h7690c48aw98eeb3613a398c7d@mail.gmail.com>
Date: Sat, 17 May 2008 23:09:02 +0200
From: "koos vriezen" <koos.vriezen@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: mplayer v4l hangs in 2.6.25.2/4 (likely regression)
Cc: linux-kernel@vger.kernel.org, mchehab@infradead.org
In-Reply-To: <d4e708d60805171306n698192aas66b42a9468253448@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d4e708d60805170954n6b2044c7h306bc6cb76bf798d@mail.gmail.com>
	 <20080517111639.21a3e177@infradead.org>
	 <d4e708d60805171211q1a1966a3i78dc3dc98d275dd1@mail.gmail.com>
	 <20080517122640.2d15aeed@infradead.org>
	 <20080517123452.79b82be2@infradead.org>
	 <d4e708d60805171306n698192aas66b42a9468253448@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/17 koos vriezen <koos.vriezen@gmail.com>:
> 2008/5/17 Arjan van de Ven <arjan@infradead.org>:
>
>> > so.. bttv first takes "fh->cap.vb_lock" in vidiocgmbuf, then calls videobuf_mmap_setup(), and the first thing that does
> is to also take fh->cap.vb_lock!  This isn't even an ABBA deadlock,
> but a straight AA deadlock :)
>
> Looks like I'm the only one actually running this code ;-)

Just to emphases the happy ever after, this TV card is from '97. So no
offense meant.

> Hmm, using v4l2 (mplayer .. -tv noaudio:driver=v4l2:devic..) works
> with audio now (used to be the other way around). I can live with
> that.

And I'm very glad that I can finally drop the v4l1 compat support.

Best regards,

Koos Vriezen
