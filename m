Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbZHHCTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbZHHCTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 22:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZHHCTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 22:19:13 -0400
Received: from smtp-out.google.com ([216.239.33.17]:22903 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbZHHCTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 22:19:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:content-transfer-encoding:x-system-of-record;
	b=A4ow4ReoMML9fNcz7BcDBKpCuu/L00Yz8g+0tV1M6HXp3LmbEbCJy4aodLNxKSsjD
	1Py0amppNrExTzllLsbJg==
MIME-Version: 1.0
Date: Fri, 7 Aug 2009 19:19:07 -0700
Message-ID: <a55d774e0908071919s7b365f84o3baa19c8d6fbe899@mail.gmail.com>
Subject: power_supply class/framework question
From: Brian Swetland <swetland@google.com>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(feel free to redirect me to a different mailing list if there's a
more appropriate place to ask this question)

I'm working on cleaning up some code to more correctly use the power
supply framework (have the battery driver receive notification from
the wall/usb power supplies, etc), and ran into a slight snag.  For
mobile usb powered devices, we need to know how much current can
safely be consumed by the charge circuit -- generally this is one of:
none, <500mA or 1000mA, which correspond to "no power supply", "usb
power supply", or "wall power supply".

I can use power_supply_am_i_supplied() to determine if I'm receiving
power, but there's no way to determine either how much (if I have one
power supply that indicates max current available) or which supply (if
I define a separate "ac" and "usb" power supply).

I'd be happy to throw together some patches to handle this, but was
wondering if there was any preference in how such information would be
made available.

Thanks,

Brian
