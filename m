Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYBWAb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYBWAb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbYBWAbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:31:15 -0500
Received: from wr-out-0506.google.com ([64.233.184.232]:33744 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbYBWAbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:31:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DuqNQpZsY2Qlsn6NXiyur3rJXOc/S8AOMUccWe1WFiyX8KAhk8ro5l54sqvYMQLKMNVD3XMuK917/hGVO/6hZ1tk2zwy37yy09FFW+Bv6YJCm+ix4h4hpUZV2f1F0KbGn4NRyvxkGoP4wbDQ9ZrZY0dvP/tp+GrgD4m1I8M7XO0=
Message-ID: <75b66ecd0802221631w624f6d33ked903c176f7d076d@mail.gmail.com>
Date: Fri, 22 Feb 2008 19:31:12 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Stephen Oberholtzer" <oliverklozoff@gmail.com>
Subject: Re: How to diagnose a process stuck in D state?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <8abd1bfd0802221508i373d37e7hd6ad7702bde25330@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8abd1bfd0802221508i373d37e7hd6ad7702bde25330@mail.gmail.com>
X-Google-Sender-Auth: 4dee61f1eee14a00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 6:08 PM, Stephen Oberholtzer
<oliverklozoff@gmail.com> wrote:
> First off: I'm not subscribed to the list (I don't think I could
>  handle the volume), so please make sure you CC me if you reply.
>
>  I run an application on one of my machines; it often hangs, with the
>  process stuck D state.  When this happens, the process sticks around
>  until I reboot the machine.
>

Run "dmesg".  Often when this happens you'll find that the kernel has Oopsed.

Lee
