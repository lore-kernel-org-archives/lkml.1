Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbYADQJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbYADQJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 11:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYADQJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 11:09:37 -0500
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:26854 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751847AbYADQJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 11:09:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=xqe9nezDNVtP6Ij3bmI/Sw9SsjwFovYEjcQAgLUvUJNi0RTOMDxT1sADe9l/qK6ky/c2rDikRqDjdHTnZeHanloHiw2e9Lh1g9P5cxFm6wfRw8upDEfCS6tozWx28G9k/O73MyZGyiy2+glmwpjuv4Q8a3gK2cGXGgCQOlKBKig=  ;
X-YMail-OSG: gF2tul8VM1ndAKRaUnV48W8gCsnlNs22A2g17TOwEtuVLul9K6F0oxMDFzkIXhSxCDcS3rKNoA--
Date: Fri, 04 Jan 2008 08:09:33 -0800
From: David Brownell <david-b@pacbell.net>
To: yi.y.yang@intel.com, pavel@ucw.cz
Subject: Re: [linux-pm][PATCH] base: Change power/wakeup output from "" to 
 "unsupported" if wakeup feature isn't supported by a device
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
 <20080104114832.GA4114@elf.ucw.cz>
In-Reply-To: <20080104114832.GA4114@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080104160933.B01D81FBAB5@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This patch changes empty output to "unsupported" in order that a user knows
> > wakeup feature isn't supported by this device when he/she
> > 'cat /sys/devices/.../power/wakeup', please consider to apply,
> > thanks.
>
> What about simply removing "wakuep" file if wakeup is not supported?

It may not *stay* unsupported, so I think changing it in either
of those permanent ways would be confusing/misleading.

For example, USB devices have multiple states ... minimally, an
unconfigured state, and a configured state.  Some have multiple
configurations.  Only configured states can be wakeup-capable.
So a given device might have three states, but support wakeup
except in one of them...

- Dave

