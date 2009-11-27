Return-Path: <linux-kernel-owner+w=401wt.eu-S1751510AbZK0BWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbZK0BWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 20:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbZK0BWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 20:22:48 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:38576 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbZK0BWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 20:22:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BYki4A3ZwG+w14xQKQ7JPnrAsQVBlxBd8AWFBoOSaSsWEhkPISRGPVJ67mwYtmVnwS
         p68SkOQIlwiDsM+ETUSXyxMu3HJClPXvZpHRRVsmWwCCEU26KQ81/Ae4S97iJU5Eqzhy
         +OXiY2xJJqmqv2CCxY8Q07jMpA2O6Q2DbwR74=
Date: Thu, 26 Nov 2009 17:22:49 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Vincent Perricone <vhp@buffalo.edu>, linux-kernel@vger.kernel.org
Subject: Re: Keyboard driver not refreshing settings when unplugged.
Message-ID: <20091127012249.GI6936@core.coreip.homeip.net>
References: <58ccc7770911112150y4b5adebfq4401df46b20d2867@mail.gmail.com> <4AFCBEBF.3010607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFCBEBF.3010607@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 08:04:47PM -0600, Robert Hancock wrote:
> On 11/11/2009 11:50 PM, Vincent Perricone wrote:
>> I noticed a bug which may possibly be part of the Linux kernel.  If
>> one were to enable a setting on the keyboard(caps lock) and then
>> unplug that keyboard.  Upon re-plugging it in or another, the system
>> will still keep caps lock enabled.  When the user then goes and
>> enables caps lock on their own keyboard which assumes the setting is
>> disabled, the system then turns caps lock off, even though the user
>> wanted it on.
>>
>> 2.6.31-14-generic
>
> USB or PS/2 keyboard? I don't know that the kernel even can tell if a  
> PS/2 keyboard has been unplugged or not..

Depends on the box. PS/2 devices normally send 0xaa 0x00 when plugged in
but that may get suppressed, especially on laptops.

-- 
Dmitry
