Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbZG2TQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbZG2TQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 15:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbZG2TQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 15:16:15 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:52352 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbZG2TQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 15:16:14 -0400
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jul 2009 15:16:13 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=whoFakkfVEuqLjepTRgHA5wVEBhFAoYCRHqk1/teGHp15BJPhVMqoP/C1ZehbYYtac
         LnH4fPXSqdJmz1rQoIXMZoYvBnuMWKNkOqHhqdgdNsd8Kqyk7XUX4qr606cv6yCR8QRv
         jNLb+Roz5WDo2p40sIxEykNPp83xHWqNczdH4=
MIME-Version: 1.0
In-Reply-To: <844950876@web.de>
References: <844950876@web.de>
Date: Wed, 29 Jul 2009 20:08:41 +0100
Message-ID: <9b2b86520907291208la807c87nad3e8ce62d6d2bad@mail.gmail.com>
Subject: Re: Show module version sysfs file for built-in modules?
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: devzero@web.de
Cc: Tomas Carnecky <tom@dbservice.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/29/09, devzero@web.de <devzero@web.de> wrote:
> what about this ?
>
> neoware:/sys/module/8139too # cat /sys/module/8139too/version
> 0.9.28
>
> neoware:/sys/module/8139too # modinfo 8139too |grep "^version:"
> version:        0.9.28
>
> the latter should work completely without consulting the kernel for that
> information.
>
> regards
> roland
>
>>List:       linux-kernel
>>Subject:    Show module version sysfs file for built-in modules?

modinfo clearly won't work for *built in* drivers.  Apparently
/sys/module/$MODULE/version doesn't work for built in modules either.
Hence this proposal.

Alan
