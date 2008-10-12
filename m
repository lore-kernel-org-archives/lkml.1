Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbYJLQxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbYJLQxd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 12:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbYJLQxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 12:53:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:48933 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbYJLQxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 12:53:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TVnWiE+FW03wWvvgnpbGyyJz1Iy0laPBrVy6R8kUioazCiFAXsUylWp8uZYuv+l9Ei
         OvrzhXPaebeeNHrqWYqvk3PTaKWkIEPnsmbUDsNrtOakloOG2gGad0wXt9vBkx4fSY+P
         DI4JzNkm7ROoIElztrU4zuKJx+nwKCN/jr0/w=
Message-ID: <524f69650810120953t2ec8100cpdddc3ddfce0406d9@mail.gmail.com>
Date: Sun, 12 Oct 2008 11:53:19 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Jeff Layton" <jlayton@redhat.com>
Subject: Re: [linux-cifs-client] Fwd: [PATCH] Fix CIFS compilation with CONFIG_KEYS unset
Cc: rjw@sisk.pl, "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>,
       cooldavid@cooldavid.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081012095903.33427ee8@tleilax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810121315.37203.rjw@sisk.pl>
	 <524f69650810120640v41778375wf0a7662e773da26f@mail.gmail.com>
	 <20081012095903.33427ee8@tleilax.poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2008 at 8:59 AM, Jeff Layton <jlayton@redhat.com> wrote:
> On Sun, 12 Oct 2008 08:40:39 -0500
> "Steve French" <smfrench@gmail.com> wrote:
>
>> Rafael and Guo-Fu,
>> The following change to address the compile error that you noted is
>> slightly different than what you suggested but should fix what you
>> found.
>>
>
> Actually, I like Adrian/Rafael's fix better. I think we should avoid
> cluttering up the code with #ifdef's where possible. key_put() already
> is a no-op when CONFIG_KEYS is disabled. We might as well do the same
> thing with key_revoke().
I don't think it matters much - but we probably shouldn't be
overriding global functions.

-- 
Thanks,

Steve
