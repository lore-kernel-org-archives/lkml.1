Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbYL2MhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbYL2MhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbYL2MhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:37:08 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:38677 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbYL2MhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:37:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MzmFND/DjPf0SNamAkKN1P1Z1ES+H6qCFadIRNYK/p8ISZ4lRCW8/gVk6HeFKvxlyM
         iU3uWC4/L1f9N5fVvGqPzQD5Vh1V0xulXjIBJFBUeFiRiX5lHO0TtLjoGOouzRHAYK4+
         /VuQZCkoR5Wtp8MQZ1BH0+4qAiDHVq7mj2fW4=
Message-ID: <8bd0f97a0812290437m75b7b7f8rf472c5f98870572d@mail.gmail.com>
Date: Mon, 29 Dec 2008 07:37:04 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andy Whitcroft" <apw@canonical.com>
Subject: Re: [PATCH 1/1] serial: RS485 ioctl structure uses __u32 include linux/types.h
Cc: "Alan Cox" <alan@redhat.com>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1228215625-18317-1-git-send-email-apw@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228215625-18317-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2008 at 06:00, Andy Whitcroft <apw@canonical.com> wrote:
> In the commit below a new struct serial_rs485 was introduced for a new
> ioctl:
>
>    commit c26c56c0f40e200e61d1390629c806f6adaffbcc
>    Author: Alan Cox <alan@redhat.com>
>    Date:   Mon Oct 13 10:37:48 2008 +0100
>
>        tty: Cris has a nice RS485 ioctl so we should steal it
>
> This structure uses the __u32 types for some of its members, which leads
> to the following compile error:

looks like this was posted on Nov 3 already ...
http://lkml.org/lkml/2008/11/3/240
-mike
