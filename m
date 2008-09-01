Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYIADpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYIADpn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 23:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbYIADpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 23:45:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:41663 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbYIADpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 23:45:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=t32l3WvqcY+YlskJMN5DFJBMjDpz4/iC6zJallzqxz+RXFuKgT12/PdR/iZKffn/Fi
         OF29S5letB+rZsdlRoIDT3UjxqKawIzbsVOPbsAvHeDj4MLEpUoatoMjXk9t6JQVIFdn
         NR4w2cmERB57Ik5v0rUbHS5EZxBPpdWcGTE5M=
Message-ID: <86802c440808312045x508ac0fbu3c9408b26f823ce7@mail.gmail.com>
Date: Sun, 31 Aug 2008 20:45:33 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: amd k6-2 mtrr not detected fix
Cc: "Krzysztof Helt" <krzysztof.h1@wp.pl>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com
In-Reply-To: <48BAB074.50809@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080831155828.d7dd0a76.krzysztof.h1@wp.pl>
	 <48BAB074.50809@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 7:53 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Krzysztof Helt wrote:
>>
>> It seems that the same problem affects Cyrix and
>> Centaur/VIA cpus. Can some x86 guy inspect the
>> mtrr initialization code ?
>>
>
> *GROAN*
>
> I would prefer if we could move the CPU detection code before the MTRR code;
> I don't think there is an inherent reason why we shouldn't be able to.  It
> would be much preferrable to scattering all kinds of CPU detection
> information all over the system.
>
> I am going to be away today so I can't look at this myself until tomorrow at
> the earliest (tomorrow is a holiday here, though, so I can't promise I'll be
> around then either.)
>
will send one for Helt to test it...

YH
