Return-Path: <linux-kernel-owner+w=401wt.eu-S1762741AbXEUNy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762741AbXEUNy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 09:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756437AbXEUNyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 09:54:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:50924 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938AbXEUNyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 09:54:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=eMYe12gKIbK6Cna5CxXRNWMi77/aS54MtMdYavYdSgw6CG/VrlmrBzX8asRWqyy+q7fz0dOV9bFcqCY73SK/9Us7PA471/t5dGLYQ0TQIxqAhvcUlRG+ciS7tQV4I6CPMFkX3gTSGB3IvH/mrREmFJ2wndUNGdP+grvxilHCBNU=
Message-ID: <84144f020705210654q2a64d186sd4e1b4f746bed7bb@mail.gmail.com>
Date: Mon, 21 May 2007 16:54:12 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: [PATCH 12/32] Blackfin arch: Fix bug using usb keyboard crashes kernel
Cc: "Bryan Wu" <bryan.wu@analog.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <600D5CB4DFD93545BF61FF01473D11AC0B175252@limkexm2.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <600D5CB4DFD93545BF61FF01473D11AC0B175252@limkexm2.ad.analog.com>
X-Google-Sender-Auth: 78e4704731efecad
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On 5/21/07, Hennerich, Michael <Michael.Hennerich@analog.com> wrote:
> During initcalls: con_init is called, and returns because of
> !display_desc.

[snip]

Aah, I missed that bit.

On 5/21/07, Hennerich, Michael <Michael.Hennerich@analog.com> wrote:
> I don't see where vc_cons[].d in between there is initialized.

Indeed. Your fix looks good. Thanks again for the explanation.
