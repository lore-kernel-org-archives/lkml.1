Return-Path: <linux-kernel-owner+w=401wt.eu-S933933AbZFLKe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933933AbZFLKe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757566AbZFLKeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:34:50 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:34208 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756605AbZFLKet convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:34:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=tHFAVZDoSSVriga0gqX8ZcKZHcXOXhjcMoginnuNkZ7dJpETw4zDPcr+OK1Odu3myn
         2B+jJaBzQsEVF23WnOrBIl6yD7h8EKYoas0r8Jk3gSg88mnfX1JjV88qFfL9uAiFekmQ
         waHBxJAS44fOsd+GrEqfQm8nyvm9bZX8XiF80=
MIME-Version: 1.0
In-Reply-To: <20090612113320.73e6f7f1@lxorguk.ukuu.org.uk>
References: <1244802468-13667-1-git-send-email-vapier@gentoo.org> 
	<20090612113320.73e6f7f1@lxorguk.ukuu.org.uk>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 12 Jun 2009 06:34:32 -0400
Message-ID: <8bd0f97a0906120334v2a1bfabr3af883b5cd1ee3a0@mail.gmail.com>
Subject: Re: [PATCH] tty: fix unused warning when TCGETX is not defined
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 06:33, Alan Cox wrote:
> On Fri, 12 Jun 2009 06:27:48 -0400 Mike Frysinger wrote:
>> If TCGETX is not defined, we end up with this warning:
>> drivers/char/tty_ioctl.c: In function ‘tty_mode_ioctl’:
>> drivers/char/tty_ioctl.c:950: warning: unused variable ‘ktermx’
>>
>> Since the variable is only used in one case statement, push it down to
>> the local case scope.
>
> If I wasn't so nice I'd just make it and the lack of BOTHER definitions
> on platforms error. Really there shouldn't be anyone without the features
> defined ;)

if i knew a lick about these extended tty pieces, i'd look at hooking them up

are these really arch specific ?
-mike
