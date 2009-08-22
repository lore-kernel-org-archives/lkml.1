Return-Path: <linux-kernel-owner+w=401wt.eu-S933009AbZHVRVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009AbZHVRVN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 13:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755836AbZHVRVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 13:21:13 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:51845 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbZHVRVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 13:21:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=h0o1dqzCSZbNoT2SZ17/wmNjgwTXcaCCLnBdagSmpVMulP5nqCl8NszWXa442t6fdp
         s/+1rBj9sJNn2m3vHGTmAeqOsfRSPgTi4/NAmEkIf32+bDaU1rxTHLTmcYn3M4u6BErF
         OeDoLuujivMKfizSGxM0QhEviuFoOgma6bpVo=
Message-ID: <4A902904.2090008@gmail.com>
Date: Sat, 22 Aug 2009 19:21:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-7.5 Thunderbird/3.0b3
MIME-Version: 1.0
To: Trilok Soni <soni.trilok@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: haptics devices linux driver support
References: <5d5443650908221004y5b893382m368dc18a38636c1b@mail.gmail.com>
In-Reply-To: <5d5443650908221004y5b893382m368dc18a38636c1b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2009 07:04 PM, Trilok Soni wrote:
> Does anyone know example Linux drivers for haptics devices?

Yup, drivers/misc/phantom.c for Sensable Phantom (the old one over PCI).
The rest needed (esp. floating point computation) is done in userspace.

Then, all force-feedack drivers under drivers/input and drivers/hid.

What exactly do you want to know?
