Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375Ab0BRTnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 14:43:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:36161 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab0BRTnL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 14:43:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WSSiZGDaP+J6Rk9tZxvZ5K9T+YMaMNRuRwupD0HMJiZD6DrDI/mwZHkkC4cD/X+dCB
         DYZ3pQFPPM3itWcRZqzxV56tPZOhVRCkDufJWO6mwh/Pq2jxtRdV6RpdGQ6k/419KDkV
         59pfHOIKmwhlTji9RPQVNJZ117BHMXpTdL3qw=
MIME-Version: 1.0
In-Reply-To: <4B7D8FA5.40901@zytor.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
	 <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>
	 <87eikj54wp.fsf@basil.nowhere.org>
	 <ff13bc9a1002180153g308b0f3dxb59959936d1e343b@mail.gmail.com>
	 <20100218101156.GE5964@basil.fritz.box>
	 <ff13bc9a1002180227j70e0748ag49d88c3034e3900d@mail.gmail.com>
	 <4B7D7060.1080908@zytor.com>
	 <ff13bc9a1002181049v2605b442y9f33008548b58d48@mail.gmail.com>
	 <4B7D8FA5.40901@zytor.com>
Date: Thu, 18 Feb 2010 20:43:10 +0100
X-Google-Sender-Auth: 9a45414ba9462f9e
Message-ID: <ff13bc9a1002181143n1b0220bfje3579b3a5601fc01@mail.gmail.com>
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if available
From: Luca Barbieri <luca@luca-barbieri.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We don't care about 486 SMP.  And yes, I think it is a better option.
> At least an assembly option, once implemented, will *stay* implemented
> and won't break due to some obscure gcc change.

After looking at it a bit more I fully agree: I'll resubmit with a
cli/popf assembly implementation and without the SSE code (which can
be done later if desired).
