Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbYI3NzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbYI3NzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 09:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbYI3NzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 09:55:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:16165 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbYI3NzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 09:55:12 -0400
Message-ID: <ac3eb2510809300655u319f8a9v58e4825f97ee329c@mail.gmail.com>
Date: Tue, 30 Sep 2008 15:55:10 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Frans Pop" <elendil@planet.nl>
Subject: Re: CD tray closes spontaneously after opening it
Cc: "Tony Vroon" <tony@vroon.org>, linux-kernel@vger.kernel.org,
       "Tejun Heo" <tj@kernel.org>, "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <200809301447.35915.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809301247.05367.elendil@planet.nl>
	 <200809301401.23160.elendil@planet.nl>
	 <ac3eb2510809300535s1a9a1dk1bd8b1080385e864@mail.gmail.com>
	 <200809301447.35915.elendil@planet.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 2:47 PM, Frans Pop <elendil@planet.nl> wrote:
> On Tuesday 30 September 2008, Kay Sievers wrote:
>> You might need:
>> http://git.kernel.org/?p=linux/hotplug/udev.git;a=commitdiff;h=f755fd56
>>57b619fd27160ad202fc5d773d096e9c
>
> Yes, I'd seen that new rule, but:
> - that fix is already included in the udev version I'm using
> - I'm seeing the issue on /dev/hda (IDE DVD drive), not on /dev/sr*

Does:
  /sbin/udevadm monitor --env
print something while you see the tray closing?

Does this also happen when you set:
  /proc/sys/dev/cdrom/autoclose
to 0?

Kay
