Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbZIAQG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbZIAQG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 12:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbZIAQG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 12:06:57 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:56948 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZIAQG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 12:06:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SnOVcm5P7miU26yab+0TP9dlLEHLywf7pKDg8xr1mRSHyw7Ydfjmt0xm/Jx1QZ6vZZ
         tuGfStDiEWyKBEFhp3ThuLmFfY3iR2S7CCtTaip+r9wVif4Bwwg9BtKg5HTmymvmLj5S
         XgDYapGXH4I0CYkMZc3LzRVKkZ88z7Ss2VbNU=
Message-ID: <4A9D469B.9060005@lwfinger.net>
Date: Tue, 01 Sep 2009 11:06:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       aquilaver@yahoo.com, linux-kernel@vger.kernel.org,
       Dan Williams <dcbw@redhat.com>, Kai Engert <kengert@redhat.com>,
       Jean Tourrilhes <jt@hpl.hp.com>, Tim de Waal <tim.dewaal@yahoo.com>,
       Roy Marples <uberlord@gentoo.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Christian Lamparter <chunkeey@web.de>,
       =?UTF-8?B?QmrDtnJuIFN0ZWluYnJpbms=?= <B.Steinbrink@gmx.de>,
       Tim Gardner <tim.gardner@canonical.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] wireless: mark prism54 as deprecated and mark for removal
References: <1251819116-10004-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1251819116-10004-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> The preferred modules is p54 which also supports FullMAC

This needs to be "modules are" or "module is". I know p54 is really a
family, but I think you specifically mean p54pci here.

> PCI / Cardbus devices. We schedule removal for 2.6.34. Reason
> to remove this is no one really is testing prism54 anymore,
> and while it works p54 provides support for the same hardware.
                     ===
p54pci?

> It should be noted I have been told some FullMAC devices may not
> have worked with the SoftMAC driver but to date we have yet to
> recieve a single bug report regarding this. If there are users
  =======
receive

> out there please let us know!
  =========

Those words can be removed.

Otherwise, ACK.

Larry

