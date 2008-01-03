Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbYACHS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbYACHS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 02:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYACHSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 02:18:17 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:4839 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbYACHSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 02:18:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=bjY02CiZ93QFFVnwA5c6JSLaeCMRNMJ80KKCr26sPXzvM4G9N1Y0EwjENT/rcfWJP4o1O5h9eY0l+bm3/zMfiYML/91cy3Zz+aBx3lxnhmVZSyB1cpURWroHoRaUEKswp3EERUMVTrZhGGecHML7ixChQ19lc111kj70jEA79AQ=
Date: Thu, 3 Jan 2008 08:24:04 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: gregkh@suse.de, stern@rowland.harvard.edu, peterz@infradead.org,
       david-b@pacbell.net, davem@davemloft.net, krh@redhat.com,
       stefanr@s5r6.in-berlin.de, dbrownell@users.sourceforge.net,
       James.Bottomley@HansenPartnership.com, a.zummo@towertech.it,
       cbou@mail.ru, dwmw2@infradead.org, khali@linux-fr.org,
       i2c@lm-sensors.org, linux1394-devel@lists.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, linux-scsi@vger.kernel.org,
       rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Message-ID: <20080103072404.GB1677@ff.dom.local>
References: <20080103055019.GA4885@darkstar.te-china.tietoenator.com> <20080103070609.GA1677@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103070609.GA1677@ff.dom.local>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 08:06:09AM +0100, Jarek Poplawski wrote:
> On Thu, Jan 03, 2008 at 01:50:20PM +0800, Dave Young wrote:
> > Convert semaphore to mutex in struct class.
> ...
> > One lockdep warning detected as following, thus use mutex_lock_nested with SINGLE_DEPTH_NESTING in class_device_add
> > 
> > Jan  3 10:45:15 darkstar kernel: =============================================
> > Jan  3 10:45:15 darkstar kernel: [ INFO: possible recursive locking detected ]
> > Jan  3 10:45:15 darkstar kernel: 2.6.24-rc6-mm1-mutex #1
> > Jan  3 10:45:15 darkstar kernel: ---------------------------------------------
> ...
> > If there's anything missed please help to point out, thanks.
> 
> Dave, IMHO it's not 'the right' way to do it: [...]

OOPS! (I was sleeping...) Unless it has turned out it's not so hard
here, and you are quite sure there should be no more warnings after
this one nesting annotation - then of course, this is the right way!

Sorry (?)
Jarek P.
