Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbYAGDt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbYAGDt5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 22:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYAGDts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 22:49:48 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:32505 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753187AbYAGDtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 22:49:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5WxvX9I6DmG4FRd+rtRqPJwS9Txojy1xhoDBfSenJfujzuef82Q4btbl5EupR6UJxScGKkTSdspXAlKG/rPM5UQgIADxT4cHZfB5LMI/sdg7GSbEQFairniwJT+bfcYyK1Y1uIl9mWtrq0vjx3V6CxMO4CCvhYP3cnXan12tva0=  ;
X-YMail-OSG: 74ZlBhMVM1lNtUKvJJ.Uvd1Vj738G7jnUuZYj7.Oix68duJBoKj8C5A3hd4QFLS0oTurP.Votw--
From: David Brownell <david-b@pacbell.net>
To: yi.y.yang@intel.com
Subject: Re: [linux-pm][PATCH] base: Change power/wakeup output from "" to "unsupported" if wakeup feature isn't supported by a device
Date: Sun, 6 Jan 2008 19:49:43 -0800
User-Agent: KMail/1.9.6
Cc: Olivier Galibert <galibert@pobox.com>,
       Alan Stern <stern@rowland.harvard.edu>, pavel@ucw.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20080104160933.B01D81FBAB5@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20080104165214.GA30672@dspnet.fr.eu.org> <1199670923.3551.10.camel@yangyi-dev.bj.intel.com>
In-Reply-To: <1199670923.3551.10.camel@yangyi-dev.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801061949.44408.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 January 2008, Yi Yang wrote:
> 
> > How about not changing a userland-visible interface gratuitously?
>
> "empty" can't tell a user the state of wakeup of a device, so it is
> necessary to change it.

Words don't say anything at all in isolation.  For example,
here the current tristate behavior has been documented for
several years now ... and that's the only thing that could
have conveyed any meaning whatever.

I can't agree that it's even slightly "necessary" to make
such a grutuitous and backwards-incompatible change.


