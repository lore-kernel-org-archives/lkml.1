Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbZKSOfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbZKSOfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 09:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZKSOfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 09:35:05 -0500
Received: from gv-out-0910.google.com ([216.239.58.186]:36416 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbZKSOfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 09:35:03 -0500
MIME-Version: 1.0
In-Reply-To: <20091119143008.GA719@srcf.ucam.org>
References: <20091118195342.GA13627@srcf.ucam.org> <20091118200712.GA14026@srcf.ucam.org> 
	<ac3eb2510911181306g221e8940xfbcf8b8e7fa9a56e@mail.gmail.com> 
	<20091118213355.GA16630@srcf.ucam.org> <ac3eb2510911190309y6d0d8445wd907fc5664595c6f@mail.gmail.com> 
	<20091119130107.GB20949@srcf.ucam.org> <ac3eb2510911190529p6810508fve4941f3077dfd3d9@mail.gmail.com> 
	<20091119141634.GA311@srcf.ucam.org> <ac3eb2510911190625i7432644aod6e99829b8a03dc4@mail.gmail.com> 
	<20091119143008.GA719@srcf.ucam.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 19 Nov 2009 15:34:53 +0100
Message-ID: <ac3eb2510911190634m20947c86w78340d22eff290ca@mail.gmail.com>
Subject: Re: [PATCH] [RFC] Add support for uevents on block device idle 
	changes
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Zeuthen <david@fubar.dk>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, linux-hotplug@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 15:30, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Thu, Nov 19, 2009 at 03:25:59PM +0100, Kay Sievers wrote:
>> On Thu, Nov 19, 2009 at 15:16, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> > It could, but it seems a bit of a hack. It'd still also require the
>> > timer to be in the kernel, so we might as well expose that to userspace.
>>
>> Sure, but a userspace configurable policy for an in-kernel disk-idle
>> powermanagent sounds fine, compared to a single-subscriber
>> userspace-only disk-idle event interface. :)
>
> Well, we still need to expose this for the access pattern modifying. I
> really don't see the issue with the single subscriber being devkit-disks
> - none of the operations involved are atomic, so we're inherently racy
> here.

Single-subscriber event interfaces are usually a no-go for generic
infrastructure like this. We still have the unmodified HAL running
until it is dead, and this works only because there are no such
awkward interfaces. In a few years we will probably have diskfoo
replacing dk-disks, and then ... :)

Kay
