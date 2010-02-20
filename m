Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab0BTOT2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:19:28 -0500
Received: from mail-iw0-f177.google.com ([209.85.223.177]:43408 "EHLO
	mail-iw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952Ab0BTOT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:19:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BpR3h+KEIY/QNvCsH+5DD+u+htXDKPf6YRNtEzOOxb38BeeZt3K1GTNQr+WP+roOD8
         rOOWLfUGV8DtkyNgLbSOgWDt2dNMjAzl8z+z5r/2Jw0ze4Niqd+EgnjQFUOYqB97/j0H
         Rg9IvSn+5i/tEyq+x0Z9ShpHjtfSv923s3Lak=
MIME-Version: 1.0
In-Reply-To: <1266597540.2383.20.camel@virtubuntu-alpha>
References: <1266597540.2383.20.camel@virtubuntu-alpha>
Date: Sat, 20 Feb 2010 16:19:23 +0200
Message-ID: <94a0d4531002200619t4f0b6947q2a4876d2df56059c@mail.gmail.com>
Subject: Re: One Video Decoding API to rule them all
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Peter Paul <abnominales@web.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 6:39 PM, Peter Paul <abnominales@web.de> wrote:
> currently we've got three APIs to accelerate video decoding in hardware,
> but to cover all available video decoding hardware, an application
> writer would have to support all of them.
> There is VDPAU which has a prominent supporter with nvida and is
> implemented by the proprietary nvidia and S3 driver.
> Than there is VA-API that is implemented in the proprietary poulsbo
> driver and that can use VDPAU or AMD's proprietary XvBA as a backend.
> And more recently we got CrystalHD that is implemented by Broadcom's
> eponymous driver and targets their dedicated video decoding chips.
> Now there are already applications that take advantage of one or more of
> those APIs, but hardly anyone can support all of them, thus always
> excluding users of specific hardware.
> I think it would therefore be helpful to have an official statement
> which API is the preferable one so, that the open source drivers and
> applications could migrate to that one.

Who cares about the API's? I think first we need implementations, then
people can re-factor the API's.

Currently most people can use all of them through FFmpeg so there's
not much problem. So the standard API could be FFmpeg for now.

There's also OpenMAX IL which most embedded vendors provide, like
Texas Instruments. But at least on the Nokia N900 we decided to drop
the wrapper and access the ioctls directly.

Cheers.

-- 
Felipe Contreras
