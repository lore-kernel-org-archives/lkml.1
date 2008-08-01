Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbYHANnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbYHANnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 09:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYHANnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 09:43:09 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:21862 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbYHANnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 09:43:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Cr+uq5qT0QGoGhZqVy1c8IYJdA+gAC97aASeRrsJ0cABJcDvIHnAf0xL5NvvwQ7Nxa
         yNoXEg2qKs0RzTS6i9VeBeCm0CZ8aGTh3Ahvyy89ZemO27FHL/XGBWZadRDiNWOrQSnE
         rTLYfOzj0WOBiq24jThDoqgrwVuzFihI2oxSM=
Message-ID: <b6c5339f0808010643i58dbb2a7jf459359451061ae4@mail.gmail.com>
Date: Fri, 1 Aug 2008 09:43:05 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] ath5k : ath5k_config_interface deadlock fix
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Jiri Slaby" <jirislaby@gmail.com>,
       "Dave Young" <hidave.darkstar@gmail.com>, johannes@sipsolutions.net,
       tomasw@gmail.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       linville@tuxdriver.com, stable@kernel.org
In-Reply-To: <20080801011415.ff4821a3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080801074014.GA3341@darkstar> <4892C2CA.7010003@gmail.com>
	 <4892C359.9000304@cs.helsinki.fi>
	 <20080801011415.ff4821a3.akpm@linux-foundation.org>
X-Google-Sender-Auth: 70341cfe3a314cea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2008 at 4:14 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 01 Aug 2008 11:03:37 +0300 Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>
>> Jiri Slaby wrote:
>> > Dave Young napsal(a):
>> >> In the drivers/net/wireless/ath5k/base.c, there's recursive locking of
>> >> sc->lock
>> >
>> > Should be fixed already:
>> > http://git.kernel.org/?p=linux/kernel/git/linville/wireless-2.6.git;a=commitdiff_plain;h=bc05116ab33d30342e2b4b1bcc6d6e1184e9df97
>>
>> I guess that didn't make it to -stable?
>
> (cc stable!)

Not to worry, the commit that introduced it was
9d139c810a2aa17365cc548d0cd2a189d8433c65, which as far as I can tell
came in after 2.6.26.

-- 
Bob Copeland %% www.bobcopeland.com
