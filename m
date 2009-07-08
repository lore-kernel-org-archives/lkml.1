Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbZGHUeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbZGHUeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 16:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbZGHUeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 16:34:14 -0400
Received: from mail-vw0-f199.google.com ([209.85.212.199]:43247 "EHLO
	mail-vw0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbZGHUeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 16:34:13 -0400
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jul 2009 16:34:13 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Dg/ZYfRQoXil3ocJEOPHamRJMRmbTy4bJ7MV8kD/4rlX70uI9X/wWTo2DoQlxihB72
         Ou3qJj9slln8un6zuXn4aRnzxwT8chTtyVAH2mMA6Pqy1z1q3eo4XyXM/T3aK5Gg9/52
         8ovIhXYw8dqpKNKxXvWgAOZcyCR4/vYF2MUf8=
MIME-Version: 1.0
In-Reply-To: <1247081981.18386.10.camel@johannes.local>
References: <1246873983.20908.0.camel@johannes.local>
	 <19f34abd0907081228p541d1cdao85f37aaa479fcfc5@mail.gmail.com>
	 <1247081981.18386.10.camel@johannes.local>
Date: Wed, 8 Jul 2009 13:28:49 -0700
X-Google-Sender-Auth: c95daa15f2ae506a
Message-ID: <70318cbf0907081328m2542d999l7865add3145cd48@mail.gmail.com>
Subject: Re: [PATCH] kmemcheck: fix sparse warning
From: Christopher Li <sparse@chrisli.org>
To: linux-sparse@vger.kernel.org
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 8, 2009 at 12:39 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> Everybody take me off the CC please then :) This has been discussed far
> too many times already. In this special case, the warning probably isn't
> all that useful, but ISTR Linus saying that he wanted it this way.

Right. I would keep the warning in sparse. I think it is better with
the compound statement. It is easier to read which block is which.

> -       do if (ptr) {                                                   \
> +       do { if (ptr) {                                                 \

BTW, if does not hurt to put the "if (ptr)" to a separate line.

Chris
