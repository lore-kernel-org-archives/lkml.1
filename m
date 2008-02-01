Return-Path: <linux-kernel-owner+w=401wt.eu-S1761891AbYBAVNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761891AbYBAVNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 16:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbYBAVM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 16:12:57 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:27405 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757600AbYBAVM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 16:12:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NjKPB+PLZZ450q2R79l6RlGk+EO9nypvJrKeq+cqwPbAKFVMUGMnMawFWwKwNxEX6yOoBZ0EokTw7JWjHgEyI6ealXrtSQxJkXcmMGFvWw+AX44mlmr6goFKq77kVbVLwbRUnTl0ssQeCxOxvJxytlLr2+OzpJkopSM3Ru3pxZU=  ;
X-YMail-OSG: HV_7.b0VM1nCjdAIlJVbCuYYlDVj9lrB821_asTln6v136fFgoRUD1.Xc5WvVpJyDp9Pu_PERA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Removing dev.power.power_state (WAS: Feature Removals for 2.6.25)
Date: Fri, 1 Feb 2008 13:12:53 -0800
User-Agent: KMail/1.9.6
Cc: linux-pm@lists.linux-foundation.org, Harvey.Harrison@gmail.com,
       Alan Stern <stern@rowland.harvard.edu>
References: <200801312128.10700.david-b@pacbell.net>
In-Reply-To: <200801312128.10700.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802011312.53404.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 January 2008, David Brownell wrote:
> Quoth Harvey Harrison:
> 
> > Ping?
> > What:	dev->power.power_state
> > When:	July 2007
> 
> ... there are still quite a few users left, and a new one was (sigh)
> recently added.
> 
>  - drivers/rtc/rtc-sa1100.c ... new usage, merged last week

Fixed in a patch I just sent.

>  - drivers/spi/... some controller drivers use this (look easy to fix)

Ditto.

- Dave
