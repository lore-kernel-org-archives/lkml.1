Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbYACHVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbYACHVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 02:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYACHVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 02:21:38 -0500
Received: from hs-out-0708.google.com ([64.233.178.243]:40736 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752411AbYACHVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 02:21:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Mq0MzXDKZwPneCLraw4c+1JazZZwJFqx93X9P2oXJbdwx7YK2ab/JwtREoMSgRta01xUPeMuklfmp8lVlAiydEZ3SMdAw8t13LY5eTFzEtxMWh8IZPz7tmvXIAonSPYBvKmi/O7vDsXeInUc1kdDQz7eSIpMtpEHMKJxuYGRRko=
Message-ID: <a8e1da0801022321u236d5f23ub6b5b8b61ebea505@mail.gmail.com>
Date: Thu, 3 Jan 2008 15:21:36 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Jarek Poplawski" <jarkao2@gmail.com>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Cc: gregkh@suse.de, stern@rowland.harvard.edu, peterz@infradead.org,
       david-b@pacbell.net, davem@davemloft.net, krh@redhat.com,
       stefanr@s5r6.in-berlin.de, dbrownell@users.sourceforge.net,
       James.Bottomley@hansenpartnership.com, a.zummo@towertech.it,
       cbou@mail.ru, dwmw2@infradead.org, khali@linux-fr.org,
       i2c@lm-sensors.org, linux1394-devel@lists.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, linux-scsi@vger.kernel.org,
       rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080103072404.GB1677@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080103055019.GA4885@darkstar.te-china.tietoenator.com>
	 <20080103070609.GA1677@ff.dom.local>
	 <20080103072404.GB1677@ff.dom.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 3, 2008 3:24 PM, Jarek Poplawski <jarkao2@gmail.com> wrote:
> On Thu, Jan 03, 2008 at 08:06:09AM +0100, Jarek Poplawski wrote:
> > On Thu, Jan 03, 2008 at 01:50:20PM +0800, Dave Young wrote:
> > > Convert semaphore to mutex in struct class.
> > ...
> > > One lockdep warning detected as following, thus use mutex_lock_nested with SINGLE_DEPTH_NESTING in class_device_add
> > >
> > > Jan  3 10:45:15 darkstar kernel: =============================================
> > > Jan  3 10:45:15 darkstar kernel: [ INFO: possible recursive locking detected ]
> > > Jan  3 10:45:15 darkstar kernel: 2.6.24-rc6-mm1-mutex #1
> > > Jan  3 10:45:15 darkstar kernel: ---------------------------------------------
> > ...
> > > If there's anything missed please help to point out, thanks.
> >
> > Dave, IMHO it's not 'the right' way to do it: [...]
>
> OOPS! (I was sleeping...) Unless it has turned out it's not so hard
> here, and you are quite sure there should be no more warnings after
> this one nesting annotation - then of course, this is the right way!

Thanks ;)
I don't know if there's other possible warning places with this mutex
or not,  if you have any ideas about this, please tell me.

>
> Sorry (?)
> Jarek P.
>
