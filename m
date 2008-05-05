Return-Path: <linux-kernel-owner+w=401wt.eu-S1758482AbYEEIcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482AbYEEIcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbYEEIck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 04:32:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:59982 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbYEEIcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 04:32:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iV5UdrRFqdYqzNgQSo9jvPQRXAPV8aCDacESwgvdi9RZqvGBQO8tgD3YfG9nWkrIDzD5tAOHWUbiVDc6e0hNP1lLdyAbdi0sfuQLkQ1zzi6oFFDl1cSfHKnrL3ppiHjs3rqCtM6hJugnlUw+A9fkSFDw/ynKaKOfoXe4VU9dgBE=
Message-ID: <44c63dc40805050132s602874eci66d60eaf9bbe9d57@mail.gmail.com>
Date: Mon, 5 May 2008 17:32:38 +0900
From: "minchan Kim" <barrioskmc@gmail.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 4/5] core of reclaim throttle
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <2f11576a0805050124q5b91ff3dm70918f80017cb936@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080504201343.8F52.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080504215819.8F5E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080504221043.8F64.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <44c63dc40805042221s4eb347acu6e7d86310696825f@mail.gmail.com>
	 <2f11576a0805050124q5b91ff3dm70918f80017cb936@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see.

My gmail client hide that contents.
I am sorry :-)

On Mon, May 5, 2008 at 5:24 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> >  >  +       /* in some situation (e.g. hibernation), shrink processing shouldn't be
> >  >  +          cut off even though large memory freeded.  */
> >  >  +       if (!sc->may_cut_off)
> >  >  +               goto shrinking;
> >  >  +
> >
> >  where do you initialize may_cut_off ?
> >  Current Implementation, may_cut_off is always "0" so always goto shrinking
>
> please see try_to_free_pages :)
>



-- 
Thanks,
barrios
