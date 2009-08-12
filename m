Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbZHLIVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbZHLIVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 04:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbZHLIVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 04:21:54 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:54729 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbZHLIVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 04:21:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wIFR8oqnMBUGxeEEjNQYXPuZ6N9V0IQBpOZWe2bXVITnvkq0Glr1OwZ2uCBE+M1MH6
         AY7zu1B/Wpa99OGz6HV2bY7B1i4jniQgh9V0w/B2+tlxG6T9XnuG2m7VtBQJHmoFuH5N
         SguuvcaSEihNBt0y8PxpBSPZ+iNAPbfqFNu7w=
MIME-Version: 1.0
In-Reply-To: <20090812081550.GG23832@elf.ucw.cz>
References: <1250064219-7372-1-git-send-email-penberg@cs.helsinki.fi>
	 <1250064219-7372-2-git-send-email-penberg@cs.helsinki.fi>
	 <1250064219-7372-3-git-send-email-penberg@cs.helsinki.fi>
	 <1250064219-7372-4-git-send-email-penberg@cs.helsinki.fi>
	 <1250064219-7372-5-git-send-email-penberg@cs.helsinki.fi>
	 <1250064219-7372-6-git-send-email-penberg@cs.helsinki.fi>
	 <1250064219-7372-7-git-send-email-penberg@cs.helsinki.fi>
	 <20090812081550.GG23832@elf.ucw.cz>
Date: Wed, 12 Aug 2009 11:21:53 +0300
X-Google-Sender-Auth: 6a14c0029360b7a9
Message-ID: <84144f020908120121j542a895fw5f4cdda18890d417@mail.gmail.com>
Subject: Re: [PATCH 7/7] w35und: Remove some write-only struct members
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       Sandro Bonazzola <sandro.bonazzola@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Wed, Aug 12, 2009 at 11:15 AM, Pavel Machek<pavel@ucw.cz> wrote:
> On Wed 2009-08-12 11:03:39, Pekka Enberg wrote:
>> There's no point in keeping around struct members that are only written
>> to but never read.
>>
>> Cc: Pavel Machek <pavel@ucw.cz>
>> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
>
> ACK, but... Note I no longer have access to the hardware. It is
> probably collecting dust in czech suse labs somewhere.

OK, do you still want to be CC'd on the patches? I much appreciate the review!

Btw, is there someone at czech suse labs interested in testing w35und?
I don't have the hardware either which leaves us with just one
tester... :-)

                         Pekka
