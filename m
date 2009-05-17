Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbZEQPjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbZEQPjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 11:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbZEQPjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 11:39:00 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:62970 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbZEQPi6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 11:38:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JQbT9FzGMgXt03r4Jo3Qp0jS+Mr/Guzg6Sbkj4Zxa8A3WSIfu117xNxWxgJMfaITh3
         eYItO784ko8wYcQkOtiHf33E0zNJYbXDuvUAvlrzoWc5yva/f4l/ug39fS8Va5bovx/G
         iH8cSkH83fGJMa7SOrmHzBVO7HfzbCwV2Rzik=
MIME-Version: 1.0
In-Reply-To: <20090515144628.GE2773@tuxdriver.com>
References: <5a44caba0905150740n3bf90e05i17a74e82f35edcf4@mail.gmail.com>
	 <20090515144628.GE2773@tuxdriver.com>
Date: Sun, 17 May 2009 16:38:58 +0100
Message-ID: <5a44caba0905170838l2876df90q200f9a8b6411f7ce@mail.gmail.com>
Subject: Re: Regression: 2.6.30-rc5 and rt2x00 / rt2500pci
From: Ken Lewis <kennylewis@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-net@vger.kernel.org,
       linux-wireless@vger.kernel.org, davem@davemloft.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/15 John W. Linville <linville@tuxdriver.com>:
> On Fri, May 15, 2009 at 03:40:44PM +0100, Ken Lewis wrote:
>> I've been looking for a bug in Linux-Next that makes my rt2500pci
>> wireless card unusable. ...
>
> Please apply this patch:
>
>        http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/0002-mac80211-avoid-NULL-ptr-deref-when-finding-max_rate.patch
>
> A pull request was sent to Dave M. a couple of days ago.  I imagine
> that it will make its way to Linus shortly.

Thank you, John. The patch makes 2.6.30-rc5 work for me -- no more bug
dump and the wireless card works fine.

I'm about to try and see if it *also* makes rt2x00 work when applied
against the linux-next tree (and next-20090515 in particular).

Take care.
Ken.Lewis
