Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbYJLQ6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbYJLQ6B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 12:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340AbYJLQ5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 12:57:50 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:13368 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbYJLQ5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 12:57:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UgatXeuHe+YdO2vGqYni9CCG3ZavGw5AH9KRjO6mxqxwv11rTRtlametNlMZ1qOrJL
         IGxplBicNUudm6y1NgvmjrisphVKjwLfsMqxbcC/boM6L7WFk2/uN38tM0WvpJQodPTg
         K8EjNmIkqrpEyDrQ3xaniQ0SdYp+mLjBqJOWA=
Message-ID: <524f69650810120957t1a81f23lf3fd75fee78e72c3@mail.gmail.com>
Date: Sun, 12 Oct 2008 11:57:47 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Jeff Layton" <jlayton@redhat.com>
Subject: Re: [linux-cifs-client] Fwd: [PATCH] Fix CIFS compilation with CONFIG_KEYS unset
Cc: rjw@sisk.pl, "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>,
       cooldavid@cooldavid.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <524f69650810120953t2ec8100cpdddc3ddfce0406d9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810121315.37203.rjw@sisk.pl>
	 <524f69650810120640v41778375wf0a7662e773da26f@mail.gmail.com>
	 <20081012095903.33427ee8@tleilax.poochiereds.net>
	 <524f69650810120953t2ec8100cpdddc3ddfce0406d9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2008 at 11:53 AM, Steve French <smfrench@gmail.com> wrote:
> On Sun, Oct 12, 2008 at 8:59 AM, Jeff Layton <jlayton@redhat.com> wrote:
>> On Sun, 12 Oct 2008 08:40:39 -0500
>> "Steve French" <smfrench@gmail.com> wrote:
>>
>> Actually, I like Adrian/Rafael's fix better. I think we should avoid
>> cluttering up the code with #ifdef's where possible. key_put() already
>> is a no-op when CONFIG_KEYS is disabled. We might as well do the same
>> thing with key_revoke().
> I don't think it matters much - but we probably shouldn't be
> overriding global functions.

To clarify, I like fixing it in keys.h better than overriding it in
cifs, but in the meantime we need an ifdef in cifs until keys.h
changes.



-- 
Thanks,

Steve
