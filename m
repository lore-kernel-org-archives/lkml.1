Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbYFBO4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbYFBO4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 10:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYFBOzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 10:55:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:20099 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbYFBOzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 10:55:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=CO6fHhlRr9MGp9GY2jXwQZR61Cn+pcP/PcFuVAXjy38fssYaYINg1c8D+M680HjQbqy4NK1fZq2YE4awYr65sODa5H2ucHMSCqZYuU6foOpRp7G3lJMfP5w3WUPTZ5e1+SW5Xtc9/sfB/C60HtNZUlzoeb/K3fks4bW+avplazU=
Message-ID: <b6c5339f0806020755s3fe1976dg207de2e01635e43d@mail.gmail.com>
Date: Mon, 2 Jun 2008 10:55:49 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [Bug #10825] appletouch after wakeup
Cc: "Justin Mattock" <justinmattock@gmail.com>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <200806021640.43225.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
	 <200806021510.37992.oliver@neukum.org>
	 <b6c5339f0806020706v5f48bc54tb2c17d0537d3ef5a@mail.gmail.com>
	 <200806021640.43225.oliver@neukum.org>
X-Google-Sender-Auth: 853bc4064f21e02e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2008 at 10:40 AM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Montag, 2. Juni 2008 16:06:51 schrieb Bob Copeland:
>> Just curious, why is the reset quirk is needed since <= 2.6.25 worked fine?
>
> I don't know. I suspect it is related to timing and you are just vastly
> unlikelier to hit the issue under < 2.6.25.

Yeah that jives with my unsuccessful bisection attempts.

At any rate, I retested and the reset quirk does indeed fix the regression for
me as well.  Thanks!

-- 
Bob Copeland %% www.bobcopeland.com
