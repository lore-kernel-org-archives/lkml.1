Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbZKMCEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbZKMCEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 21:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbZKMCEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 21:04:45 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:33115 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbZKMCEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 21:04:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ojR3rE+B5YdSthzQ3q4wevTOkVwAByGRhFtlQCuA3x3/bm7oSVTTCpCtRrSn5jZg0I
         tmtaze9nzfTPVGn0T4lpdWsiHlWXXpioxtGH4SQQhcRfRVdxNvvd0tZXFiBwNCt/owIK
         c58BBf6Jvh9xV/b4u6j1SbE62qedzhfbVOuIQ=
Message-ID: <4AFCBEBF.3010607@gmail.com>
Date: Thu, 12 Nov 2009 20:04:47 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Vincent Perricone <vhp@buffalo.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Keyboard driver not refreshing settings when unplugged.
References: <58ccc7770911112150y4b5adebfq4401df46b20d2867@mail.gmail.com>
In-Reply-To: <58ccc7770911112150y4b5adebfq4401df46b20d2867@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2009 11:50 PM, Vincent Perricone wrote:
> I noticed a bug which may possibly be part of the Linux kernel.  If
> one were to enable a setting on the keyboard(caps lock) and then
> unplug that keyboard.  Upon re-plugging it in or another, the system
> will still keep caps lock enabled.  When the user then goes and
> enables caps lock on their own keyboard which assumes the setting is
> disabled, the system then turns caps lock off, even though the user
> wanted it on.
>
> 2.6.31-14-generic

USB or PS/2 keyboard? I don't know that the kernel even can tell if a 
PS/2 keyboard has been unplugged or not..
