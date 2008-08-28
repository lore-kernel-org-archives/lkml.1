Return-Path: <linux-kernel-owner+w=401wt.eu-S1758337AbYH1XGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337AbYH1XGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 19:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbYH1XGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 19:06:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58468 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbYH1XGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 19:06:18 -0400
Message-ID: <48B72F53.9080109@kernel.org>
Date: Thu, 28 Aug 2008 16:05:55 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Adrian Bunk <bunk@kernel.org>, Tejun Heo <tj@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Takashi Iwai <tiwai@suse.de>,
       fuse-devel@lists.sourceforge.net
Subject: Re: [ANNOUNCE] OSS Proxy using CUSE
References: <48B6F711.1040604@kernel.org> <20080828200120.GA16462@cs181140183.pp.htv.fi> <20080828221828.GB2855@kroah.com>
In-Reply-To: <20080828221828.GB2855@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> 
> Independant of that, I can see a number of uses for the CUSE code.  One
> would be emulating /dev/pilot for old palm pilot software that things it
> wants to talk to a serial port, yet really a libusb userspace program
> can handle all of the data to the USB device instead.
> 

I think that's probably another bad example... I would think serial port 
emulation would be better handled by ptys, and/or a specific serial port 
emulation module.

The big problem with using ptys for serial port emulation is that they 
currently don't handle BREAK at all.

	-hpa
