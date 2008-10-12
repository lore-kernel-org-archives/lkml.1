Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbYJLSr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbYJLSr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 14:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbYJLSrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 14:47:15 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:41343 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbYJLSrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 14:47:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cKvFel/gGFE/OERXdqOgLK9jdNxfB9tVQgHjmMfQ5eaS/R6A/s0dNKKnjR17DvRlgi
         a8YDEnMG/bM/otI0GZ8hux+ATF0u5x8v4+cirwUQdN4hBFJAouHDKll/7ek9IrH2U3Ln
         gHccGo8neL2Cfq4uVTHl4FYT168Xepsa6FNHs=
Message-ID: <524f69650810121147j4ad79f77p348a3814b7f05d01@mail.gmail.com>
Date: Sun, 12 Oct 2008 13:47:12 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-cifs-client] Fwd: [PATCH] Fix CIFS compilation with CONFIG_KEYS unset
Cc: "Jeff Layton" <jlayton@redhat.com>, "David Miller" <davem@davemloft.net>,
       netdev@vger.kernel.org,
       "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>,
       cooldavid@cooldavid.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200810121909.53233.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810121315.37203.rjw@sisk.pl>
	 <524f69650810120953t2ec8100cpdddc3ddfce0406d9@mail.gmail.com>
	 <524f69650810120957t1a81f23lf3fd75fee78e72c3@mail.gmail.com>
	 <200810121909.53233.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2008 at 12:09 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, 12 of October 2008, Steve French wrote:
>> On Sun, Oct 12, 2008 at 11:53 AM, Steve French <smfrench@gmail.com> wrote:
>> > On Sun, Oct 12, 2008 at 8:59 AM, Jeff Layton <jlayton@redhat.com> wrote:
>> >> On Sun, 12 Oct 2008 08:40:39 -0500
>> >> "Steve French" <smfrench@gmail.com> wrote:
>> >>
>> >> Actually, I like Adrian/Rafael's fix better. I think we should avoid
>> >> cluttering up the code with #ifdef's where possible. key_put() already
>> >> is a no-op when CONFIG_KEYS is disabled. We might as well do the same
>> >> thing with key_revoke().
>> > I don't think it matters much - but we probably shouldn't be
>> > overriding global functions.
>>
>> To clarify, I like fixing it in keys.h better than overriding it in
>> cifs, but in the meantime we need an ifdef in cifs until keys.h
>> changes.
>
> Well, adding an empty definition for key_revoke() in the !CONFIG_KEYS case
> makes sense anyway IMO.

I agree.  ACKED

-- 
Thanks,

Steve
