Return-Path: <linux-kernel-owner+w=401wt.eu-S933440AbZDASjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440AbZDASjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 14:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762738AbZDASim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 14:38:42 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:39634 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760865AbZDASik convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 14:38:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CdboWlGWo2u5sp8jde0/GiBJBlnVZ83ZczWGJfLz7tacPGMg6HrfBHdQDNZFRFMnXG
         iu5R0yHvlIBcoph42FsehDGAnr37b5WryF0ZHh+kttKr36crjspz5JsUXnDAOdej/vQb
         d1Fo3UerVCGfWafV+2HrQja9koiUmYQPV9WAU=
MIME-Version: 1.0
In-Reply-To: <20090122114955.32F3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <2f11576a0901160316u20030f4u51c9e4c059398b70@mail.gmail.com>
	 <20090116152338.GB9357@kroah.com>
	 <20090122114955.32F3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Date: Thu, 2 Apr 2009 00:08:36 +0530
Message-ID: <5d5443650904011138p78686bf7oc040762cd3536387@mail.gmail.com>
Subject: Re: lowmemory android driver not needed?
From: Trilok Soni <soni.trilok@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Greg KH <greg@kroah.com>, Paul Mundt <lethal@linux-sh.org>,
       "Arve Hj?nnev?g" <arve@android.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       Brian Swetland <swetland@google.com>, arve@google.com,
       San Mehat <san@android.com>, Robert Love <rlove@google.com>,
       linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       "ext Juha Yrj?l?" <juha.yrjola@solidboot.com>,
       viktor.rosendahl@nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Jan 21, 2009 at 8:20 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:

>>
>> Care to work on your mem_notify patch again and bring it up to date?
>> That would be a good place to start working from, right?
>
> Unfortunately No ;)
>
> I should rewrite memory notification patchset from scratch.
> the new version will construct on memcg infrastrcture.
>
> Why?
>
> last year, I received many feedback from lkml folks and my article reader.
> (I monthly write kernel patch introduction article to japanese web
>  magazine and receive some feedback periodically)
>
> I learned many people want flexibility notification.
> (per workload, per user, et al)
> eg. nokia lowmem driver have exception process defined by uid.
>
> at top of last year, I thought memcg don't provide good infrastructure.
> the first version memcg is just pretty funny joke. if its config turn on,
> memory workload performance decrease ~30% although the user don't use
> memcg at runtime. then nobody use it.
> but recently, KAMEZAWA hiroyuki (and Li zefan, Daisuke Nishimura et al)
> dramatically improvement memcg performance.
> now, memcg overhead become less than 1%.
>
> Then, I think any memory accounting activity should use this infrastructure.
> That's my homework.

Any updates on top of  mem_notify v6 patches?  Is there any WIP for
mem_notify with memcg infrastructure as you have pointed out above?


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
