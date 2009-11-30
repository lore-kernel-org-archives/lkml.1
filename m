Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbZK3JVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbZK3JVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbZK3JVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:21:38 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:33472 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbZK3JVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:21:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RMmnipm1ePyYyWMsr9rmq79dT380KNYzTqy008wvTqvoMxjufZNv0Wt0hXdbnqOotZ
         pDn4Eq41//u8BB2QYVPZY2/I/UPvzjHdEICaNJOrTiHP8fD0BNewbLOmIS3L1SP0x3C8
         mw3uD6UPHmsZKxjFXCcXspX+/mzrWmJscbMqw=
MIME-Version: 1.0
In-Reply-To: <20091130174103.b5c05570.sfr@canb.auug.org.au>
References: <20091130164415.f418834b.sfr@canb.auug.org.au>
	 <2375c9f90911292151t2deb8530idd96ce50ced74d80@mail.gmail.com>
	 <20091130174103.b5c05570.sfr@canb.auug.org.au>
Date: Mon, 30 Nov 2009 17:21:43 +0800
Message-ID: <2375c9f90911300121j437ffa9bleec585ebc8e62ea3@mail.gmail.com>
Subject: Re: linux-next: manual merge of the sysctl tree with the net tree
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 2:41 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Américo,
>
> On Mon, 30 Nov 2009 13:51:03 +0800 Américo Wang <xiyou.wangcong@gmail.com> wrote:
>>
>> > diff --cc net/sctp/sysctl.c
>> > index ae03ded,d50a042..0000000
>> > --- a/net/sctp/sysctl.c
>> > +++ b/net/sctp/sysctl.c
>> > @@@ -285,19 -241,7 +242,17 @@@ static ctl_table sctp_table[] =
>> >                .extra1         = &zero,
>> >                .extra2         = &addr_scope_max,
>> >        },
>> >  +      {
>> > -               .ctl_name       = CTL_UNNUMBERED,
>> >  +              .procname       = "rwnd_update_shift",
>> >  +              .data           = &sctp_rwnd_upd_shift,
>> >  +              .maxlen         = sizeof(int),
>> >  +              .mode           = 0644,
>> > -               .proc_handler   = &proc_dointvec_minmax,
>> > -               .strategy       = &sysctl_intvec,
>> > ++              .proc_handler   = proc_dointvec_minmax,
>>
>> Hey, what's this??
>
> If you mean "what is this strange looking patch", then it is the output
> from "git diff --cc" after a merge conflict has been fixed up, but before
> it is committed.  The '-' lines were added by one side of the merge or
> the other, but removed from the final result.  The line with '++' did not
> appear in either branch, but is in the final result.  The lines with a
> single '+' appear in one of the branches or the other and in the final
> result as well.
>

Thanks for teaching this! I thought it was a mistake, it is not. :)
No problem then.
