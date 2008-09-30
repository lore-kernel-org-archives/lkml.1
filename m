Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYI3BGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYI3BGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 21:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYI3BFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 21:05:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:56699 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbYI3BFx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 21:05:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=w6/njLVq+9M1xw9TxHDaA987NrN/j8SQDRPKi9a9ah5HgZSDE+aO4A1UBVLfttWqx+
         IC6pbGJKlDEDbZmg9/0tHHeosc21MA2JqP2FbGrPfAdEP47XedeM0tEKvmFnELxZ+iNH
         U07YbuPACmTs8WKjRXSmX9vmjEHDt/vnGEAaA=
Message-ID: <86802c440809291805r71877ad1wc68525c1ca0603e1@mail.gmail.com>
Date: Mon, 29 Sep 2008 18:05:51 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "=?ISO-8859-1?Q?J.A._Magall=F3n?=" <jamagallon@ono.com>
Subject: Re: Strange mtrrs in Aspire One
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080930015733.5c6ea984@werewolf.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080930015733.5c6ea984@werewolf.home>
X-Google-Sender-Auth: 4fe5d4ff0c803266
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 4:57 PM, J.A. Magallón <jamagallon@ono.com> wrote:
> Hi all...
>
> My aspire one is giving some strange MTRR settings with rc7-git5 (and
> prevous kernels, but that is what I run now...):
>
> one:~> cat /proc/mtrr
> reg00: base=0xfffe0000 (4095MB), size= 128KB: write-protect, count=1
> reg01: base=0xfffc0000 (4095MB), size= 128KB: uncachable, count=1

could make mtrr_cleanup to support 128K gran_size

> reg02: base=0x00000000 (   0MB), size= 256MB: write-back, count=1
> reg03: base=0x10000000 ( 256MB), size= 256MB: write-back, count=1
> reg04: base=0x1f800000 ( 504MB), size=   8MB: uncachable, count=1
> reg05: base=0x1f600000 ( 502MB), size=   2MB: uncachable, count=1
> reg06: base=0x1f500000 ( 501MB), size=   1MB: uncachable, count=1

> reg07: base=0x00000000 (   0MB), size= 128KB: uncachable, count=1
..
>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)

last entry is really sick...

YH
