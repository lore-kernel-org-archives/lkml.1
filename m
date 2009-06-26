Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbZFZIAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbZFZIAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 04:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZFZIAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 04:00:31 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:42818 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbZFZIAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 04:00:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bar7IU5j7Qn4u4tM5jXOCOcZclzRjMeX1Fk9hh51pGNpxw7jlKgo7T9QF+uZDpmehj
         gITfvqpDyLNQNUOeqpCfAlbJbwZ3JVfJXUkPzF2MJ1Wzv2foQiqQovHvoqLS1o58lAh4
         u9hColLyaQqakg3T0BMgHjEspLEE/RO0YNm+s=
MIME-Version: 1.0
In-Reply-To: <20090625091002.0b8203a7@lxorguk.ukuu.org.uk>
References: <1158166a0906241600w5f7f4ffcm49d9c849f0c27f72@mail.gmail.com>
	 <20090625091002.0b8203a7@lxorguk.ukuu.org.uk>
Date: Fri, 26 Jun 2009 10:00:32 +0200
Message-ID: <1158166a0906260100q79475523l546cddde2c0ca03@mail.gmail.com>
Subject: Re: [PATCH] allow execve'ing "/proc/self/exe" even if /proc is not 
	mounted
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 10:10 AM, Alan Cox<alan@lxorguk.ukuu.org.uk> wrote:
>> With this patch, it is possible to execute /proc/self/exe
>> even if /proc is not mounted. In the below example,
>> ./sh is a static shell binary:
>
> What if the user has procfs mounted somewherelse, what if they are in a
> chroot where you don't want them to patch the binary and re-exec it ?
>
> It would be far far cleaner for NOMMU to have a NOMMU private "reexec()"
> call that didn't rely on procfs or hacking names into the kernel.
>
> So NAK

I am ok with it. Are other people ok with adding a syscall
just for this purpose? Al?
--
vda
