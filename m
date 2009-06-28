Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbZF1O3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbZF1O3R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 10:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbZF1O3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 10:29:02 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:49316 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbZF1O3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 10:29:01 -0400
MIME-Version: 1.0
In-Reply-To: <200906281622.10072.info@gnebu.es>
References: <200906280821.58631.info@gnebu.es> <200906281437.00329.info@gnebu.es> 
	<ac3eb2510906280549w75b4da79i1f38888a9be56c4e@mail.gmail.com> 
	<200906281622.10072.info@gnebu.es>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sun, 28 Jun 2009 16:28:44 +0200
Message-ID: <ac3eb2510906280728s1d80c417w64ce6985e9ed8f64@mail.gmail.com>
Subject: Re: Kernel 2.6.30 and udevd problem
To: Alberto Gonzalez <alberto6674@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
       Dave Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 16:22, Alberto Gonzalez<alberto6674@gmail.com> wrote:
> On Sunday 28 June 2009 14:49:52 Kay Sievers wrote:
>> On Sun, Jun 28, 2009 at 14:37, Alberto Gonzalez<alberto6674@gmail.com>
> wrote:
>> > This is what I got wen the problem finally came back (it happens
>> > randomly, this time I triggered it by running glxgears, but it can happen
>> > for other reasons and none of them triggers it automatically):
>> >
>> > KERNEL[1246192153.094553] change
>> > /devices/pci0000:00/0000:00:02.0/drm/card0 (drm)
>> >
>> > UDEV  [1246192153.178593] change
>> > /devices/pci0000:00/0000:00:02.0/drm/card0 (drm)
>> >
>> > So just an endless loop of the same message again and again.
>>
>> If you see this loop and kill the udev daemon, the UDEV events will
>> stop. But do the KERNEL events continue, or do all events stop? This
>> should tell us if some udev rules trigger something here, or if it is
>> a loop in the kernel.
>
> When I kill udevd, the KERNEL messages continue.

If there isn't something else running which acts on uevents that
trigger drm events, which I wouldn't expect, it seems like a drm
kernel problem.

Kay
