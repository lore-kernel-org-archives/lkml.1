Return-Path: <linux-kernel-owner+w=401wt.eu-S1764131AbZCaXyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764131AbZCaXyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764364AbZCaXx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:53:58 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:52343 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764188AbZCaXx5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:53:57 -0400
MIME-Version: 1.0
In-Reply-To: <200903311418.53772.david-b@pacbell.net>
References: <200903260042.42091.david-b@pacbell.net> <200903311418.53772.david-b@pacbell.net>
Date: Wed, 1 Apr 2009 01:51:48 +0200
Message-ID: <ac3eb2510903311651i4c5f6805tc74fe04ee765be9c@mail.gmail.com>
Subject: Re: [patch/rfc 2.6.29 1/2] MTD: driver model updates
From: Kay Sievers <kay.sievers@vrfy.org>
To: David Brownell <david-b@pacbell.net>, dwmw2@infradead.org
Cc: Linux MTD <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 23:18, David Brownell <david-b@pacbell.net> wrote:
> On Thursday 26 March 2009, David Brownell wrote:
>> From: David Brownell <dbrownell@users.sourceforge.net>
>>
>> Update driver model support in the MTD framework, so it fits
>> better into the current udev-based hotplug framework:
>
> Hmm, no comments?  I had understood there was interest over on
> the MTD side of things in exposing more information through
> sysfs, to help avoid the need to add Even More Ioctls as part
> of support for things like NAND chips with 4KB pages, or which
> handle more than 4GBytes ...

Please have a look at this. We got asked repeatedly to provide better
hotplug/udev integration, and the patches, and having the parent
device properly assigned, would solve some of the problems people run
into currently.

Thanks,
Kay
