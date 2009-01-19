Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbZASSaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbZASSaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 13:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbZASSaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 13:30:05 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:43760 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbZASSaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:30:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i/i4+6gXdqb3oaxUo4Th6MDT5aqJVYHf2tW4WZC2KQ9ZDHdO37yxmdB0wbxTvm3YbI
         lIerieYZ9GlBuaWabS6JrSADX978LHdcNfjYxcxhxWp04NdycARMuCMQV2C28554nN+Y
         IF/0syaYlERyaAl6ByKH8h6H3C4a1ZEOLgJDA=
MIME-Version: 1.0
In-Reply-To: <200901171908.28533.arvidjaar@mail.ru>
References: <200901171908.28533.arvidjaar@mail.ru>
Date: Mon, 19 Jan 2009 10:30:01 -0800
Message-ID: <4807377b0901191030g27efac79rbd39501eb2eea4cb@mail.gmail.com>
Subject: Re: [2.6.29-rc2 regression] e100: netconsole not functional because 
	of missing firmware
From: Jesse Brandeburg <jesse.brandeburg@gmail.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: e1000-devel@lists.soutceforge.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2009 at 8:08 AM, Andrey Borzenkov <arvidjaar@mail.ru> wrote:
> [    2.008509] e100: eth0: e100_request_firmware: Failed to load
> firmware "e100/d101m_ucode.bin": -22
> [    2.010461] netconsole: failed to open eth0
> [    2.010996] netconsole: cleaning up
>
> This has been working all the time without requiring any external
> firmware to be present. Why it suddenly refuses to work now?

to use netconsole you probably need to set config option
CONFIG_FIRMWARE_IN_KERNEL=y

Hm, I wonder if we couldn't have netconsole=y select
CONFIG_FIRMWARE_IN_KERNEL in Kconfig

the arguments as to why the firmware was split out of the drivers have
already been made on this list.  Not that I agree with them, but the
decision has been made and we're (network devs) going along with it.
