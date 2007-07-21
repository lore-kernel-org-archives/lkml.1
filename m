Return-Path: <linux-kernel-owner+w=401wt.eu-S1764410AbXGUTd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764410AbXGUTd1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 15:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbXGUTdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 15:33:19 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:8425 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbXGUTdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 15:33:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a4DKlqWigcUQHRxt6flYKOCWXhFQfYfZG4PWwuiPiaT588wEly4rOtvoX8TloEddq2dbA/3dhjIW977boPkiFQ6sGfqH0RRtwErnXwQHGQhaA9Ycp3pDVy7EskZFdAaYF3/492twfcqSIPk+YhZzQaeKsU9afRCknJD2rmVCmok=
Message-ID: <71a0d6ff0707211233r52192d7aic98d2a307b044eca@mail.gmail.com>
Date: Sat, 21 Jul 2007 23:33:17 +0400
From: "Alexander Shishkin" <alexander.shishckin@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: from where comes "__moddi3"?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707211516480.6972@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0707211516480.6972@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
>
>   again, probably displaying my abject ignorance, but i wrote a
> trivial module that tries to "var % 15", and i get:
>
>   WARNING: "__moddi3" undefined!
...which comes from libgcc1 which you obviously don't want to link against.

Does (var & 0x0f) not work for you?

Regards,
-- 
Alex
