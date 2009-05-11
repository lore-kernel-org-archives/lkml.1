Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbZEKS4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbZEKS4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbZEKSz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:55:58 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:28156 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbZEKSz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:55:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XK64nnnFxSN6iqFFzkXpof8QWWyl9GSDa4gvc7TuF2ow3APs4kyGLBcfzycCeQ57aX
         /l7Y8KIs8TLnCYidoe6PvBPzlcGJvqC55WC5WcUwBZPnesKUZHEgmefELgNGDP5SxMO+
         /RjH4K9OR+Vd4uwlFn2/P7r8zoEX7hL2goVDo=
MIME-Version: 1.0
In-Reply-To: <20090506175906.GW8633@ZenIV.linux.org.uk>
References: <20090506175906.GW8633@ZenIV.linux.org.uk>
Date: Mon, 11 May 2009 13:55:57 -0500
Message-ID: <a4e6962a0905111155h4b575a70o8453938e53b88e3d@mail.gmail.com>
Subject: Re: oddity in v9fs_kill_super()
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 6, 2009 at 12:59 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> Is there any reason to do v9fs_dentry_release(s->s_root) in ->kill_sb()?
> It is called when root dentry is freed and it will be freed just fine...
>

Most likely unnecessary early paranoia on my part - I think that's
been in there since 2.6.14.
I'll look into removing it.

        -eric
