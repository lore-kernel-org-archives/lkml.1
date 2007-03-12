Return-Path: <linux-kernel-owner+w=401wt.eu-S1030358AbXCLPJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030358AbXCLPJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030369AbXCLPJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:09:05 -0400
Received: from mcr-smtp-002.bulldogdsl.com ([212.158.248.8]:3953 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030358AbXCLPJD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:09:03 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: "=?iso-8859-1?q?Llu=EDs?= Batlle" <viriketo@gmail.com>
Subject: Re: bug in select() in linux
Date: Mon, 12 Mar 2007 15:08:52 +0000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <45219fb00703120751t7acd1ae3kb77f556b81a87634@mail.gmail.com> <20070312160104.25d6b321@lxorguk.ukuu.org.uk> <45219fb00703120802y78cf4dbds6e89b58de9d0f801@mail.gmail.com>
In-Reply-To: <45219fb00703120802y78cf4dbds6e89b58de9d0f801@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703121508.52749.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007 15:02, Lluís Batlle wrote:
> Oh, of course you're right. I was inside too much layers to think of
> the tcp protocol, and I did not pay attention to it.
>
> Maybe something could be added to the manpage anyway.
>
> The bad thing is that there's no way I can use a socket for writing
> using select() if that connection has been half-closed by the other
> end. Moo.

This question comes up from time to time. I think the answer is 
ultimately "select() sucks, use poll()".

I can't exactly remember the details, but I believe POLLHUP or POLLOUT as 
flags do what you want.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
