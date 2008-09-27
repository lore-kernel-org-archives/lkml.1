Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbYI0R3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbYI0R3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbYI0R2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:28:48 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:10955 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbYI0R2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:28:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=DRWwqYg8tPJv2P7UAMZBYQQqbzvKkesaRZCHeVVcvgB7xUiTANQqKgX9twdTlQYmwd
         m6nBTgBMMhDFX6TzHycPlMg1TBpMSHSwXk4mnyJxc8zcJBBHkMdv63xJwxU9d2esdXXc
         VjTU2mpWOpoSqyeZBGUzF0jjzufjPdD0/ClpY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Steven Noonan" <steven@uplinklabs.net>
Subject: Re: [PATCH] drivers/ide/ide-probe.c: uninitialized variable 'rc'
Date: Sat, 27 Sep 2008 17:40:38 +0200
User-Agent: KMail/1.9.10
Cc: "Elias Oltmanns" <eo@nebensachen.de>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
References: <1220994461-15962-1-git-send-email-steven@uplinklabs.net> <87myifmxpk.fsf@denkblock.local> <f488382f0809101544o5aa9d9d1scdf64a1d0b004d07@mail.gmail.com>
In-Reply-To: <f488382f0809101544o5aa9d9d1scdf64a1d0b004d07@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809271740.38980.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2008, Steven Noonan wrote:
> On Wed, Sep 10, 2008 at 3:40 PM, Elias Oltmanns <eo@nebensachen.de> wrote:
> >
> > What about changing the declaration to
> >
> >        int i, uninitialized_var(rc);
> >
> > then?
> >
> 
> That's probably a -much- better idea. I'm an utter newbie to kernel
> development, so I wasn't aware of that feature.

Did I miss the final patch version?

[ Could you please re-send and/or re-cast it? ]

Thanks,
Bart
