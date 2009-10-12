Return-Path: <linux-kernel-owner+w=401wt.eu-S933115AbZJLTQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbZJLTQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933053AbZJLTQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:16:20 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:33686 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757917AbZJLTQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:16:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bOiGNYzenaQTP05Mlb+7uLMTpe73lq5GzDcW+hyXw0TjfhL/zT0vZLnKb1Hhpo0a3C
         WoqjXWJ7hv9gjdLp3j60oGD6lvqfPZV5lnS4a/ou1Do11ufcotyJuR06aPNRHpNbCUKu
         5OZ8FgqKVVTrgpCqAH5ZuutCCYHAHnyOwMjxM=
MIME-Version: 1.0
In-Reply-To: <87pr8sfp7k.fsf@basil.nowhere.org>
References: <1255357820-7122-1-git-send-email-nir.tzachar@gmail.com>
	 <87pr8sfp7k.fsf@basil.nowhere.org>
Date: Mon, 12 Oct 2009 21:15:42 +0200
Message-ID: <9b2db90b0910121215s3f875e9ax8342bc35613f7f59@mail.gmail.com>
Subject: Re: [PATCH] nconfig v4
From: Nir Tzachar <nir.tzachar@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, zippel@linux-m68k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Mon, Oct 12, 2009 at 8:21 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Nir Tzachar <nir.tzachar@gmail.com> writes:
>
>> Hello.
>>
>> This is a reworked version of nconfig, an ncurses based replacement for
>> menuconfig. The first submission was approximately a year ago. The current patch
>> is applicable to the current git tree.
>
> What are the advantages over the old menuconfig?
>
> That information should be in the patch description.

Sorry. Following is an excerpt from the original patch:

This patch was inspired by the kernel projects page, where an ncurses
replacement for menuconfig was mentioned (by Sam Ravnborg).

Building on menuconfig, this patch implements a more modern look interface using
ncurses and ncurses' satellite libraries (menu, panel, form). The implementation
does not depend on lxdialog, which is currently distributed with the kernel.


> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only.
>
