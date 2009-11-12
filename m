Return-Path: <linux-kernel-owner+w=401wt.eu-S1759971AbZKLCXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759971AbZKLCXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 21:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759928AbZKLCXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 21:23:30 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:48865 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759915AbZKLCXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 21:23:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Z4v5Wpgue3EOVVxClfVN1nUQirMAO7OSJEhWXX/E10lpYFOq9PNMn4hswh5nntYaYu
         Oa6rXP1D0W+cMXkjqBnVFqTU7RZb9YQa1XraRoMmOEkhnHeZApU42ZpZGyG78ppoJIJz
         w5wXAR9Argc0+jLscAOjjkJaV3WQmy0Crnu80=
MIME-Version: 1.0
In-Reply-To: <20091111093258.GE560@1wt.eu>
References: <4AF9D8E2.7050205@zytor.com> <4AF9E61B.5090407@zytor.com> 
	<20091110222031.GA22911@elte.hu> <20091110224222.GA28648@1wt.eu> 
	<4AF9ED78.3000106@zytor.com> <20091111055220.GA560@1wt.eu> 
	<4AFA569E.9040206@zytor.com> <20091111063617.GD560@1wt.eu> 
	<4AFA6E50.7030808@zytor.com> <20091111093258.GE560@1wt.eu>
From: Matt Thrailkill <matt.thrailkill@gmail.com>
Date: Wed, 11 Nov 2009 18:23:14 -0800
Message-ID: <a91053ef0911111823v52669d18p7e5812076a63f03e@mail.gmail.com>
Subject: Re: i686 quirk for AMD Geode
To: Willy Tarreau <w@1wt.eu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Pavel Machek <pavel@ucw.cz>, Avi Kivity <avi@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 1:32 AM, Willy Tarreau <w@1wt.eu> wrote:
> All I can say is that executing a NOP results in no state change in
> the processor except the instruction pointer which points to the
> next instruction after execution. Since a NOP changes nothing, it
> cannot be used alone to provide any privilege, access to data or
> any such thing. Since it does not perform any jump, it cannot either
> be used to take back control of the execution flow. And it is certain
> that the next instruction after it will be executed, so if the NOP
> crosses a page boundary and completes on a non-executable one, the
> next instruction will trigger the PF.
>
> So I can't see how a NOP can be used to circumvent any protection.

So a nop(l) sled won't be a problem, right?
