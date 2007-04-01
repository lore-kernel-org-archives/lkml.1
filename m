Return-Path: <linux-kernel-owner+w=401wt.eu-S933064AbXDANyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064AbXDANyn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 09:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933068AbXDANyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 09:54:43 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:22795 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933064AbXDANyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 09:54:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OiCtw6njjx8QCX0tX9FZtN4v7xtyP7oeLGRHhBfqLnwkqCMcXXJ+1Ja8wQIen5w1w3JRMCPom4CHnOjTAfgAbR79M4qdjZWxaH971LN0yyxjQShCarEtMJEo88+KlGae68n+d7AsNcU6C4MIW6u02m8oEWhxxts3+leJguhZdAE=
Message-ID: <6bffcb0e0704010654x1f9815e6x654146ae523b43b9@mail.gmail.com>
Date: Sun, 1 Apr 2007 15:54:40 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: info@sascha-curth.de
Subject: Re: Bug?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1175434753.8986.1.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1175434753.8986.1.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/04/07, Sascha Curth <info@sascha-curth.de> wrote:
> Hi,
>
> i hav essen this in my logfiles. The server wasn't rechable any more and
> a hard reset was needed....

Yes, that's a bug.

>
>
>
> Kernel: 2.6.18
> Logfile:
>
> Mar 29 22:18:07 seven ------------[ cut here ]------------
> Mar 29 22:18:07 seven kernel BUG at mm/rmap.c:522!
> Mar 29 22:18:07 seven invalid opcode: 0000 [#1]
> Mar 29 22:18:07 seven SMP
> Mar 29 22:18:07 seven Modules linked in: capi capifs st fcdsl
> Mar 29 22:18:07 seven CPU:    0
> Mar 29 22:18:07 seven EIP:    0060:[<c0151a46>]    Tainted: P S    VLI

You are using proprietary module. Please reproduce with an untainted kernel.

Regards,
Michal

-- 
Michal K. K. Piotrowski
Hurd Testers Group
(http://www.hurdtestersgroup.org/)
