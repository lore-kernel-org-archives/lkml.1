Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbYJINgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbYJINgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 09:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758114AbYJINgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 09:36:09 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:7404 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758103AbYJINgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 09:36:09 -0400
Message-ID: <ac3eb2510810090636w51e04a7fxfa36d8b016b236d@mail.gmail.com>
Date: Thu, 9 Oct 2008 15:36:07 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Arkadiusz Miskiewicz" <a.miskiewicz@gmail.com>
Subject: Re: loading ipmi_watchdog causes tons of other watchdog modules to be loaded
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200810091348.19828.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810091348.19828.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2008 at 1:48 PM, Arkadiusz Miskiewicz
<a.miskiewicz@gmail.com> wrote:
>
> No udev on the system. kernel 2.6.25.18-1.
>
> After loading ipmi_watchdog and doing "cat /dev/watchdog" tons of other,
> useles, watchdog modules is loaded. Any idea what introduced such weird
> behaviour?

I guess the /proc/sys/kernel/modprobe, which lets the kernel fork a
modprobe process when you touch a "dangling" device node, which does
not have corresponding driver.

Kay
