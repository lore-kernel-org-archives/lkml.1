Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbZKIOC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbZKIOC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 09:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbZKIOC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 09:02:28 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:47881 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871AbZKIOC1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 09:02:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=s6sTDCFrJ7Wm8Offm9AqZ+vqJQxzCrcLyB52ZhiHASV17DAmBMUvtMaeOLG28p9KXp
         g48JP5HFBKF2Axj/SBK3/77eTn/6HLL4yGNXSOBKz2XG0J/ugWRTcdsyNsHk90zkiIZ0
         YxTuyHxpsAEx8cwTwMCxQQ8JsNrsH1qpePR64=
MIME-Version: 1.0
In-Reply-To: <20091108165000.374714cb@lxorguk.ukuu.org.uk>
References: <cover.1257602781.git.andre.goddard@gmail.com> 
	<c7d3b02b5e28eaa54a5360d57dfd177c44320187.1257602781.git.andre.goddard@gmail.com> 
	<20091108165000.374714cb@lxorguk.ukuu.org.uk>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Mon, 9 Nov 2009 12:02:13 -0200
Message-ID: <b8bf37780911090602j21b0022cg695d9e20b8a88660@mail.gmail.com>
Subject: Re: [PATCH v4 10/12] string: factorize skip_spaces and export it to 
	be generally available
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux list <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@medozas.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 8, 2009 at 2:50 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Sat,  7 Nov 2009 13:16:18 -0200
> André Goddard Rosa <andre.goddard@gmail.com> wrote:
>
>> On the following sentence:
>>     while (*s && isspace(*s))
>>         s++;
>
> Looks fine but for one thing: it's actually shorter inline than moved
> into /lib so at the very least it should be a header inline not a
> function call.

I have tried header "static inline" approach per your suggestion and
code size increases by 197 bytes from:
64954     584     588   66126   1024e (TOTALS-lib.a-before)
to:
65151     584     588   66323   10313 (TOTALS-lib.a-after)

> Second minor comment. Although it never made it into the final ANSI C,
> the proposed name (and the one used in a lot of other non Linux code for
> this) is stpblk().

Thank you,
André
