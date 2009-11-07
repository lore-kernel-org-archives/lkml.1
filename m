Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbZKGXz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbZKGXz7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 18:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbZKGXz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 18:55:59 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39511 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbZKGXz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 18:55:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hsYuHcCeYyaJdZjqaY1WZrsud+PdNkdH+qeTC+BHPJ5ysIGk8c66vZ9F0YZ19YoO6U
         oA/C7biP8FUlUsUbfsNwAL+VuHMa598D6jdxEZ7i4fZOqgcTAxaGVrbOmRlhuiQfqGL0
         W6WrWfPYQAmZysHgKIDYatkxI0sGbXNhPQEd0=
MIME-Version: 1.0
In-Reply-To: <20091107234532.GA29450@linux-mips.org>
References: <1257616235-7840-1-git-send-email-tfransosi@gmail.com>
	 <20091107234532.GA29450@linux-mips.org>
Date: Sat, 7 Nov 2009 21:56:02 -0200
Message-ID: <a4c8a6d00911071556w6cf6fa5fp5a6de4a35504e422@mail.gmail.com>
Subject: Re: [PATCH] leds: add exit function to cobalt-raq led.
From: Thiago Farina <tfransosi@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, gregkh@suse.de,
       yuasa@linux-mips.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 7, 2009 at 9:45 PM, Ralf Baechle <ralf@linux-mips.org> wrote:
> On Sat, Nov 07, 2009 at 12:50:35PM -0500, Thiago Farina wrote:
>
> This driver has no exit function because it cannot be built as a module.
> I've not reviewed the driver in detail but at the very least the
> LEDS_COBALT_RAQ Kconfig statement for the driver would need to be changed
> to tristate before this patch makes any sense.

According to this thread:
"Therefore, this driver is not tristate."
http://lkml.org/lkml/2007/9/13/377
