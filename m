Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbXEaK1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbXEaK1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 06:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758414AbXEaK1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 06:27:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:29205 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758286AbXEaK1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 06:27:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kLWAwSY+gT8j1zI1jmLdKyzBFAhIhSJMzdUsH63Odq7E8+9DLkUbI3PXw9DQ2oguZEXIW3+A5nuweXGhbTjvsm4nxB5a68eOVQDhgUZiaewTRa4gYqsLVoYkBZObGyJ6PBdInpZPnDESH9o4o6Uki7SVHttaIDhKeAuqkZ7D0Hk=
Message-ID: <3d57814d0705310327q632aaa10p29254ff777d07b31@mail.gmail.com>
Date: Thu, 31 May 2007 20:27:14 +1000
From: "Trent Waddington" <trent.waddington@gmail.com>
To: "Ralf Baechle" <ralf@linux-mips.org>
Subject: Re: Portable syscall inspection
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070529123557.GA21684@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d57814d0705281559y56576567r2c23edda5f22c3cf@mail.gmail.com>
	 <20070529123557.GA21684@linux-mips.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/07, Ralf Baechle <ralf@linux-mips.org> wrote:
> Also consider that some architectures pass parts of the arguments in
> registers which on yet others are passed in memory.  Sometimes padding
> arguments are needed and many more oddities.  Similar for results.
> Inescapably such a program is a perment maintenance nightmare.

Yes, I see.  This nightmare appears to be the burden of the strace
people, god bless them.  I'm looking at moving their plethora of
#ifdefs into a library so others can be spared the nightmare.

Thanks,

Trent
