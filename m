Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbYE1Tyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbYE1Tyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 15:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbYE1Tys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 15:54:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:9168 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbYE1Tyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 15:54:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=eWncxMffYG1bwfqpmIt8309OwMdeUO6RIF6X3gMwdncL1xlk2/sxdLld0J71+hFZV/vHtsSyXlskeyJLMLjU+OyEOyraRKQnZ5gNVjV4QQ9atId1PpH6T62BMFvqlHLXJYBko0/iFB2bpJgxpD0XimFpe3e5ULcpL9iAykobpBI=
Message-ID: <84144f020805281254o16c903b6p2c14e5874d5ad67f@mail.gmail.com>
Date: Wed, 28 May 2008 22:54:47 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Steve French" <smfrench@gmail.com>
Subject: Re: optimizing out inline functions
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <524f69650805281251r1b1d99a1tc3223d15e3aeb50c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <524f69650805281251r1b1d99a1tc3223d15e3aeb50c@mail.gmail.com>
X-Google-Sender-Auth: 0d410cbb5fa67446
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 10:51 PM, Steve French <smfrench@gmail.com> wrote:
> Is one or the other style (with or without #define of empty function)
> preferred?  Does the compiler optimize both #else clauses out
> properly?  sparse and checkpatch seem to take either

Both are optimized out but empty function is preferred for type checking.
