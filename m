Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbYEEIY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbYEEIY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbYEEIYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 04:24:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:32633 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbYEEIYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 04:24:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=q8jhubf+c8iVL4mwwDoiykeH6sLZSof3LFzDKCPREDyeUPt5NfEOY/L5tf//OMmtvSgChP5cvGoYraITiEJa5U+6uueDXng+zwldSoSu0JEnZOdj263ZR4tM1sJ1/139iP0iTkFRHKh6fOTpt2a8FQZcfDWz81uaiN3MU2umUc8=
Message-ID: <2f11576a0805050124q5b91ff3dm70918f80017cb936@mail.gmail.com>
Date: Mon, 5 May 2008 17:24:20 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "minchan Kim" <barrioskmc@gmail.com>
Subject: Re: [-mm][PATCH 4/5] core of reclaim throttle
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <44c63dc40805042221s4eb347acu6e7d86310696825f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080504201343.8F52.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080504215819.8F5E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080504221043.8F64.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <44c63dc40805042221s4eb347acu6e7d86310696825f@mail.gmail.com>
X-Google-Sender-Auth: 25e8b504527e41b5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  >  +       /* in some situation (e.g. hibernation), shrink processing shouldn't be
>  >  +          cut off even though large memory freeded.  */
>  >  +       if (!sc->may_cut_off)
>  >  +               goto shrinking;
>  >  +
>
>  where do you initialize may_cut_off ?
>  Current Implementation, may_cut_off is always "0" so always goto shrinking

please see try_to_free_pages :)
