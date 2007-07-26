Return-Path: <linux-kernel-owner+w=401wt.eu-S1762615AbXGZPn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762615AbXGZPn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757596AbXGZPnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:43:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54654 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbXGZPnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:43:19 -0400
Message-ID: <46A8C112.9070504@zytor.com>
Date: Thu, 26 Jul 2007 08:43:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Xudong Guan <xudong.guan@gmail.com>
CC: Borislav Petkov <bbpetkov@yahoo.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1: no setup signature found...
References: <20070724112618.GA4431@gollum.tnic> <20070726150854.GA7034@xguan-laptop> <46A8BB6C.6050903@zytor.com> <20070726152604.GA25792@xguan-laptop>
In-Reply-To: <20070726152604.GA25792@xguan-laptop>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xudong Guan wrote:
> On 08:19(-0700) Thu 26 Jul, H. Peter Anvin wrote:
>> What distro/version of grub are you running?  I'm wondering if there are
>> some old version of grub out there which did the "load four sectors"
>> way-anciently-obsolete crap; the other possibility that comes to mind is
>> setting up the stack in an invalid manner
> 
> My grub screen shows "GRUB  version 0.91". I am playing with a qemu
> image with this version of grub came from an old Damn Small Linux distribution.
> 

Hm, the oldest on GNU's website is 0.92, so I suspect 0.91 is the
version number it had back when everyone was effectively using Grub
snapshots.  I'll try to see if I can pull Grub's CVS repository and do
some archeology.

	-hpa
