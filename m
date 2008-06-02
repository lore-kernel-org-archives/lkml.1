Return-Path: <linux-kernel-owner+w=401wt.eu-S1761753AbYFBOHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761753AbYFBOHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 10:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbYFBOGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 10:06:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:42168 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbYFBOGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 10:06:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PqVUmttlTCHnkVhH+I29wlKhNLIc6tIh3oye6DVrX77YN80f10GoOKvmWW9g092AlR/SWy7xgAFK7feMTlONeNXBOoRDwKDLWhNaCQKoTYmGPh2OPU1Acp9vBiMJ4PKIc/9485fQ2jcMuJFY+ssG/Od2ftzXBS9cHTzTJmoi2yI=
Message-ID: <b6c5339f0806020706v5f48bc54tb2c17d0537d3ef5a@mail.gmail.com>
Date: Mon, 2 Jun 2008 10:06:51 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [Bug #10825] appletouch after wakeup
Cc: "Justin Mattock" <justinmattock@gmail.com>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <200806021510.37992.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
	 <200806020915.27683.oliver@neukum.org>
	 <b6c5339f0806020544u3993a9dbh38e746449c601c5e@mail.gmail.com>
	 <200806021510.37992.oliver@neukum.org>
X-Google-Sender-Auth: 5e63975e4334f675
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2008 at 9:10 AM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Montag, 2. Juni 2008 14:44:41 schrieb Bob Copeland:
>> On Mon, Jun 2, 2008 at 3:15 AM, Oliver Neukum <oliver@neukum.org> wrote:
>> > Am Montag, 2. Juni 2008 01:09:00 schrieb Justin Mattock:
>> >> On Sun, Jun 1, 2008 at 7:37 PM, Justin Mattock <justinmattock@gmail.com> wrote:
>> >> > On Sun, Jun 1, 2008 at 6:29 PM, Oliver Neukum <oliver@neukum.org> wrote:
>> >
>> >> >> Please also apply the patch from the following link:
>> >> >> https://bugzilla.novell.com/attachment.cgi?id=213908
>> >
>> > Is this a statistically significant number of tests? How often did you see
>> > the appletouch problem? Can we consider this regression to be fixed by
>> > this patch?
>>
>> [CCed Johannes since we discussed the original problem in a separate thread]
>>
>> Oliver,
>>
>> Is the RESET_RESUME quirk needed in addition to the Novell bugzilla patch?
>
> You need both.

Yup, I booted the wrong kernel before, sorry for that.  I'll test again shortly.

Just curious, why is the reset quirk is needed since <= 2.6.25 worked fine?

-- 
Bob Copeland %% www.bobcopeland.com
