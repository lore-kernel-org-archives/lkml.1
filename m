Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbZCSGIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbZCSGIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 02:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbZCSGI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 02:08:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:51683 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZCSGI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 02:08:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GYKd6i/F1zGMqMt2wn3bdaHmurXZ8nAMlwSSWQZMvyLObqh/MU/5Np2WEtlHQ1qsnM
         xPhuA7ba78QAulkaG0+g4N4yIyJRSArvZecJJpxkk8oqy/IMTmpUerYOpm0m4oHsOuA6
         c2rJsOvRBzXrEC4D5WSnVd7K9/0VYyws8O+X0=
MIME-Version: 1.0
In-Reply-To: <d760cf2d0903181930m782932a4reda3a0b582489f5d@mail.gmail.com>
References: <49BF8ABC.6040805@vflare.org> <49BF8B8B.40408@vflare.org>
	 <alpine.DEB.1.10.0903171237180.21582@qirst.com>
	 <d760cf2d0903171028o600dc94cn7a5238520d104455@mail.gmail.com>
	 <alpine.DEB.1.10.0903171355410.26058@qirst.com>
	 <49C11088.7000205@vflare.org>
	 <alpine.DEB.1.10.0903181258110.15570@qirst.com>
	 <d760cf2d0903181029r43bf417u502b46e08348f6ae@mail.gmail.com>
	 <84144f020903181221t480caa5dhef0e581a7bef006@mail.gmail.com>
	 <d760cf2d0903181930m782932a4reda3a0b582489f5d@mail.gmail.com>
Date: Wed, 18 Mar 2009 23:08:27 -0700
X-Google-Sender-Auth: 992a0da35d5903b3
Message-ID: <84144f020903182308r1082e418k7deb441774af4d89@mail.gmail.com>
Subject: Re: [PATCH 2/3]: xvmalloc memory allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/18/09, Nitin Gupta <ngupta@vflare.org> wrote:
> I can see quite some places for cleanups (like macros for
> reaching next free block etc). Do you think CamelCase will be acceptable
> for now? and also keeping xvmalloc name? Other than these, I will
> check for potential cleanups and send updated diffs.

No, I do not think it is acceptable for core kernel code.
