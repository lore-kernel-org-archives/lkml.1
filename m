Return-Path: <linux-kernel-owner+w=401wt.eu-S1030325AbXCLPPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030325AbXCLPPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030351AbXCLPPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:15:19 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:13819 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030325AbXCLPPR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:15:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jgzhtQcn528f+9lLjY0s7+eQVrps09071QJNNVKe8yPBbekLhXwg5xhwNncp4mWDf2q6KFBO+GjZG/UUxBiogGYCn/aapfxtxp5wQLU4mkS2eniZAJal0Fkz5TGZTfIMyAk1uZsnFuLrAe1m8yMecVcssvMmywL4uT9O1aUVhGA=
Message-ID: <45219fb00703120815l79262977va0b7e3b8e59921de@mail.gmail.com>
Date: Mon, 12 Mar 2007 16:15:15 +0100
From: "=?ISO-8859-1?Q?Llu=EDs_Batlle?=" <viriketo@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: bug in select() in linux
In-Reply-To: <200703121508.52749.s0348365@sms.ed.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <45219fb00703120751t7acd1ae3kb77f556b81a87634@mail.gmail.com>
	 <20070312160104.25d6b321@lxorguk.ukuu.org.uk>
	 <45219fb00703120802y78cf4dbds6e89b58de9d0f801@mail.gmail.com>
	 <200703121508.52749.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wouldn't it be better for all of us that select() doesn't block on
write(), unless there is a socket writting buffer fulfilled? It will
be consistent with the select() specification.

2007/3/12, Alistair John Strachan <s0348365@sms.ed.ac.uk>:
> On Monday 12 March 2007 15:02, Lluís Batlle wrote:
> > Oh, of course you're right. I was inside too much layers to think of
> > the tcp protocol, and I did not pay attention to it.
> >
> > Maybe something could be added to the manpage anyway.
> >
> > The bad thing is that there's no way I can use a socket for writing
> > using select() if that connection has been half-closed by the other
> > end. Moo.
>
> This question comes up from time to time. I think the answer is
> ultimately "select() sucks, use poll()".
>
> I can't exactly remember the details, but I believe POLLHUP or POLLOUT as
> flags do what you want.
>
> --
> Cheers,
> Alistair.
>
> Final year Computer Science undergraduate.
> 1F2 55 South Clerk Street, Edinburgh, UK.
>
