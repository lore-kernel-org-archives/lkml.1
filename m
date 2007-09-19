Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbXISUcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbXISUcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 16:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbXISUcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 16:32:09 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:42411 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbXISUcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 16:32:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=l2q2s9aUiLYhytUAL7cntI53GrbAVZQ05e4pVjhu5AGiKhYIrhPO0c6+UH02CSz63hD7LgXTt51UThNhb+y/RQa6n3++B05+5WOGdB9huHe/246ddBlQjhm46Xda6g/WNtGfOG690F0lJF/4oyXECDD/jYn+kRqw0AW1FuhcaZ4=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 1/4] Linux Kernel Markers - Architecture Independent Code
Date: Wed, 19 Sep 2007 21:32:00 +0100
User-Agent: KMail/1.9.1
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, dsmith@redhat.com,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20070918211324.161373216@polymtl.ca> <20070919113737.GA18177@Krystal> <y0mtzpqvk1l.fsf@ton.toronto.redhat.com>
In-Reply-To: <y0mtzpqvk1l.fsf@ton.toronto.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709192132.00873.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 September 2007 14:53, Frank Ch. Eigler wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> 
> > [...]  Do you think I should also remove the __markers_strings
> > section from here ?
> 
> Current systemtap marker support code relies on the __markers_strings
> section.

Let users know that in comment above section definition in ld script.

Thanks!
--
vda
