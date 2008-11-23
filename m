Return-Path: <linux-kernel-owner+w=401wt.eu-S1752294AbYKWXlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbYKWXlh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 18:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbYKWXl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 18:41:29 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:42077 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYKWXl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 18:41:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=iWqclbT24qTKRM6KdLtOQYjtclfKui6wR2Z203NyDo9B62AeeMkVgqHdloBVfMMkYq
         XGoaJzzDBVpIde7gdyGz3tUcKE8GB7Q9id6fd3PVXoE6YPPpS+Ik08gCi5kBco8QBCRm
         yjbAXgYOIlXa6qCqUCPriW0eQcDnQYNrx/Ivw=
Message-ID: <86802c440811231541i4bee7589j9de44b91dddf195a@mail.gmail.com>
Date: Sun, 23 Nov 2008 15:41:27 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Dmitry Nezhevenko" <dion@inhex.net>
Subject: Re: 2.6.28 git: WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:404 generic_get_mtrr+0xea/0x120()
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>,
       "Venki Pallipadi" <venkatesh.pallipadi@intel.com>
In-Reply-To: <20081123095708.GA7502@laptop.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081120092239.GA16613@laptop.local>
	 <200811222144.31812.rjw@sisk.pl>
	 <86802c440811221343n61b9d20cue4d89c1c4b45121c@mail.gmail.com>
	 <20081123095708.GA7502@laptop.local>
X-Google-Sender-Auth: d875a1e87dac4ff1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 1:57 AM, Dmitry Nezhevenko <dion@inhex.net> wrote:
> On Sat, Nov 22, 2008 at 01:43:25PM -0800, Yinghai Lu wrote:
>>
>> can we get whole boot message? also cat /proc/mtrr
>>
>> YH
>
> dmesg: http://inhex.net/dion/tmp/dmesg-2.6.28-rc5.txt
>
> /proc/mtrr:
> reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
> reg04: base=0x0000f8000 (    0MB), size=   32KB, count=1: write-protect
> reg05: base=0x0000dc000 (    0MB), size=    8KB, count=1: write-back

so that patch workaround your BIOS setup with mtrr  mask setting.

YH
