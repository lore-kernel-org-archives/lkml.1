Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbZGAQDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbZGAQDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 12:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZGAQC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 12:02:58 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:41235 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbZGAQC5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 12:02:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=R2cHi959cylXXSM8h/7P4bnlBau1maepA7dbOfz0x7ryah5RJqNzcoUJrNYbBN5y1s
         zOw759yQEt25ckXfsI5EqrrDsGK/MzB2eoicQiAeR9MPeF4Xs/eGUMMgsYpMC54Kfmp1
         Db5OLMuuel9xiDQqRbadsp1jKGSO8kdzQSvYQ=
MIME-Version: 1.0
In-Reply-To: <20090701120814.30741.10146.stgit@warthog.procyon.org.uk>
References: <20090701120814.30741.10146.stgit@warthog.procyon.org.uk>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 1 Jul 2009 12:02:28 -0400
Message-ID: <8bd0f97a0907010902y4c6b4d86m36a1116d5af67f0@mail.gmail.com>
Subject: Re: [PATCH] FDPIC: Ignore the loader's PT_GNU_STACK when calculating 
	the stack size
To: David Howells <dhowells@redhat.com>
Cc: rgetz@blackfin.uclinux.org, lethal@linux-sh.org, gerg@uclinux.org,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 1, 2009 at 08:08, David Howells wrote:
> WARNING: This patch is slightly dangerous - it may render a system inoperable
> if the loader's stack size is larger than that of important executables, and
> the system relies unknowingly on this increasing the size of the stack.

every toolchain ive seen sets the stack size in the linker to the
default value, and the only way to change that is to manually set the
size yourself with the relevant command line option.  so it's only
going to break people who have been doing it wrong themselves --
setting the stack size to a smaller option than is acceptable.

> -       else
> +       else

this change just adds trailing whitespace ...

otherwise, just tested it and it works for me, thanks
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
-mike
