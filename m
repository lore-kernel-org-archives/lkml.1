Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab0BRJ4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 04:56:50 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:36437 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab0BRJ4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 04:56:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=vOtFWwuj2W65K6THXfUD8qwty6ipkNwZO1BsrFfhwzy9QsHGGXnxlNVSEAl3JT1cHn
         kC/tgBMtWuTzyHZNwtEkw4loUZJgGnaDJewZQrOSUkULzV4Q7U5de+MKbdvnfYltbxcN
         /T5csHCDmj93Ma2MdCaV2VC2ozwwoya9YJEKQ=
MIME-Version: 1.0
In-Reply-To: <ff13bc9a1002180153g308b0f3dxb59959936d1e343b@mail.gmail.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
	 <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>
	 <87eikj54wp.fsf@basil.nowhere.org>
	 <ff13bc9a1002180153g308b0f3dxb59959936d1e343b@mail.gmail.com>
Date: Thu, 18 Feb 2010 10:56:47 +0100
X-Google-Sender-Auth: 139285b4a92b2b87
Message-ID: <ff13bc9a1002180156s2d0c94abwcd08b9fb2aa94158@mail.gmail.com>
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if available
From: Luca Barbieri <luca@luca-barbieri.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, hpa@zytor.com, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyway, how about the previous patches?

The SSE part is not essential and can be delayed.
