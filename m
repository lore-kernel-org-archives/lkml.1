Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab0BXEaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 23:30:19 -0500
Received: from mail-iw0-f177.google.com ([209.85.223.177]:34879 "EHLO
	mail-iw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab0BXEaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 23:30:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RkItJf+jcYDw0mXCuzN1R0BaIrTQ9fGVTB5d5QB3cX3u2TDUyJdVC0UFuivtSbIPuo
         df9HS/XoMf9BTqAfwi+Uhp9LU3E2heIs+5ovsRDQ22Nbz2kpV26M1Mzf+IEm+M6jfx7d
         l9ej09tTQ/pWh5etRGEJSxMoxyF50kIjZxlKQ=
MIME-Version: 1.0
In-Reply-To: <SNT125-W3300E8CCB5A9BD2D7B9942C3410@phx.gbl>
References: <4B7CAF95.6020306@gmail.com> <20100218042626.GB11649@kroah.com>
	 <51f3faa71002172113o65a85ed6y5fa39d0b3a96f7ce@mail.gmail.com>
	 <SNT125-W3300E8CCB5A9BD2D7B9942C3410@phx.gbl>
Date: Tue, 23 Feb 2010 22:30:15 -0600
Message-ID: <51f3faa71002232030u4679b6d0yc8df0679d8e19106@mail.gmail.com>
Subject: Re: SB600 64-bit DMA BIOS misconfiguration (formerly RE: [PATCH 
	2.6.34] ehci-hcd: add option to enable 64-bit DMA support)
From: Robert Hancock <hancockrwd@gmail.com>
To: Yuhong Bao <yuhongbao_386@hotmail.com>
Cc: greg@kroah.com, shane.huang@amd.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, tj@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 9:53 PM, Yuhong Bao <yuhongbao_386@hotmail.com> wrote:
>
>> it doesn't work. Based on the libata experience with AHCI which has a
>> similar 64-bit feature flag, there are some controllers that didn't do
>> it properly, but not many (only ATI SB600 it appears, and only on
>> certain boards, as it seems it was a BIOS configuration issue).
> It seems it was solved by a DMI whitelist, but if it is a BIOS configuration issue, I think it would be better if it could be detected directly instead by reading the configuration directly from the device and correcting it if possible. Is that possible?

That would likely be the ideal solution, but only AMD would likely
have the info needed to do that, if it's possible..
