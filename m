Return-Path: <linux-kernel-owner+w=401wt.eu-S1759554AbYDQHeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554AbYDQHeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 03:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbYDQHeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 03:34:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:65026 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbYDQHeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 03:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iEw5RDca6Mb+d0vS49kQ67V9hqUMgI50bed7OTO/21vxs0f41ut3HKjSxJ0q8dAEDkpXTxIZ+/TYwcz5R8r5fIOT36zP1VrgVcCtUqhHHZwUDoFl3aURiUJNWCaRkSCj0ojiZn/6DelsfvRr35x61BHOiQLWeiBZgJ2VZP+UIvE=
Message-ID: <ed10ee420804170034g73906d04s22a53f4ef3ef495f@mail.gmail.com>
Date: Thu, 17 Apr 2008 00:34:03 -0700
From: "SL Baur" <steve@xemacs.org>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: gart: factor out common code
Cc: "Pavel Machek" <pavel@ucw.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <4806EE5F.1040305@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080415104357.GA13441@elf.ucw.cz>
	 <ed10ee420804151625i1e30abb7r98ddda53ec6e8da6@mail.gmail.com>
	 <20080416081418.GA5105@elf.ucw.cz>
	 <ed10ee420804161955o221539f9p5cbfcc9eaf4b375d@mail.gmail.com>
	 <4806EE5F.1040305@firstfloor.org>
X-Google-Sender-Auth: 8f50974aa765fe06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/08, Andi Kleen <andi@firstfloor.org> wrote:
> SL Baur wrote:

> I think the casts make it more clear because the register is 32bit.
>  The only truly ugly bit is naming a variable "tmp".

Good point.

>  > that function is too big to be inlined so you should probably drop the explicit
>  > `inline' and let the compiler decide.

> In a header static inline is needed, otherwise the compiler will warn
>  about an unused static if it's not used which is unfortunate because
>  not every includer wants to use all functions.
>
>  That said the function should probably not be in a header.

Yes.  Agreed.  I'm happy enough having common duplicated
code removed, but I know Ingo is picky about saving space
whenever he can, so I thought I would point it out now before
it becomes a maintenance issue.

Thanks for the feedback.  I'll focus harder on future reviews.

-sb
