Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab0CBDY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 22:24:28 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:51430 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab0CBDYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 22:24:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=b//TIwUnxR2LuW2fPXMq4mMhmM19dyaBoTERU86F/UbZ1dNIdIkqDoJvWbiRVnQFa5
         VSeCCWg+TUNvuLsnfQDuWifuYRY/rbMiMOxlLEOxSSj4xZjWjYAAWBka+peLSOtiEmgT
         7nK2F4RcoF2D9ctaSL6FQPQLzrpw7VIol3pVo=
MIME-Version: 1.0
In-Reply-To: <4B8C56F0.5090700@gmail.com>
References: <4B8C56F0.5090700@gmail.com>
Date: Tue, 2 Mar 2010 11:24:24 +0800
Message-ID: <2375c9f91003011924k43f03649y5b4df405d6247a79@mail.gmail.com>
Subject: Re: Notifier chains bug ?
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Oleg Kutkov <elenbert@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 2, 2010 at 8:08 AM, Oleg Kutkov <elenbert@gmail.com> wrote:
> Hello.
> I try to used notifier chains for monitoring network devices events.
> All works perfectly when just i'm connecting/disconnecting network cable or
> up/down interface via ifconfig.
> But when i try to change interface address - nothing happens. Notifier is
> don't send any events :(

I think you mean IP address? No, NETDEV_CHANGEADDR is for hardware
address, not for IP address.

If you were changing mac address, you will receive NETDEV_CHANGEADDR.
