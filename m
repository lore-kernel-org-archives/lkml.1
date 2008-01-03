Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYACHfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYACHfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 02:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbYACHfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 02:35:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:50356 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYACHfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 02:35:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=JuNiX7UgLEcKL9U9ViNpkTrKuPBlgeAqrqsuS0yL3iKI4n3YPaBbbK6clY3vT3InPGnADmyXsGeQ/CpOoh37bHSw8r4gaCApf9FPSA+wtER9O/EcVWUN2tRhy/8g9RjjTrG65xGeylfaXd1ebZDwLQfFWyS8Sw54zB386VbBZQs=
Date: Thu, 3 Jan 2008 08:41:32 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: gregkh@suse.de, stern@rowland.harvard.edu, peterz@infradead.org,
       david-b@pacbell.net, davem@davemloft.net, krh@redhat.com,
       stefanr@s5r6.in-berlin.de, dbrownell@users.sourceforge.net,
       James.Bottomley@hansenpartnership.com, a.zummo@towertech.it,
       cbou@mail.ru, dwmw2@infradead.org, khali@linux-fr.org,
       i2c@lm-sensors.org, linux1394-devel@lists.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, linux-scsi@vger.kernel.org,
       rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Message-ID: <20080103074132.GA2000@ff.dom.local>
References: <20080103055019.GA4885@darkstar.te-china.tietoenator.com> <20080103070609.GA1677@ff.dom.local> <20080103072404.GB1677@ff.dom.local> <a8e1da0801022321u236d5f23ub6b5b8b61ebea505@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0801022321u236d5f23ub6b5b8b61ebea505@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 03:21:36PM +0800, Dave Young wrote:
...
> I don't know if there's other possible warning places with this mutex
> or not,  if you have any ideas about this, please tell me.

I think lockdep is just to tell such things. So, the question is, how
much it was tested already, because if there are many warnings
reported e.g. after merging to -mm, then this could be better to re-do
it this other way... But, I hope this will not be necessary.

Jarek P.
