Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152Ab0AGP4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab0AGP4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 10:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068Ab0AGP4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 10:56:53 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:56982 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab0AGP4w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 10:56:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tsI5VJ1ehZeLmfinRPmjXDCa4PPgRdGmVv1MpV4UR/SVYY8bVpFh1H9HVPjzscZPhA
         wubF+N+lKIsJF9GbPzj0TrmEi4bcr9jlnHT4ULd2w7ul29m9R7aegh5c2K/jO7eEMw/p
         aYFrFbrRkDe61wqN6XTGji0HEVQ9zgZz/xnAs=
MIME-Version: 1.0
In-Reply-To: <20100107043241.GA19313@c2.user-mode-linux.org>
References: <1262828921-29517-1-git-send-email-a.beregalov@gmail.com>
	 <1262828921-29517-2-git-send-email-a.beregalov@gmail.com>
	 <1262828921-29517-3-git-send-email-a.beregalov@gmail.com>
	 <1262828921-29517-4-git-send-email-a.beregalov@gmail.com>
	 <20100107043241.GA19313@c2.user-mode-linux.org>
Date: Thu, 7 Jan 2010 18:56:51 +0300
Message-ID: <a4423d671001070756u2c6eb8f3p12bf3681b96ba342@mail.gmail.com>
Subject: Re: [PATCH 4/4] uml: line.c: avoid NULL pointer dereference
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/7 Jeff Dike <jdike@addtoit.com>:
> On Thu, Jan 07, 2010 at 04:48:41AM +0300, Alexander Beregalov wrote:
>> Assign tty only if line is not NULL.
>
>>       if (line)
>> +             tty = line->tty;
>>               chan_interrupt(&line->chan_list, &line->task, tty, irq);
>>       return IRQ_HANDLED;
>
> Even if the thinking is correct, aren't you missing some braces?

Oops, sorry, I will send another version.
