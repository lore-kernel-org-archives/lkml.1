Return-Path: <linux-kernel-owner+w=401wt.eu-S1759736AbYBOVMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759736AbYBOVMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbYBOVMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:12:42 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:45290 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbYBOVMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:12:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=DwgBx168ohclmcNJhpU8ZvY7Igy5goBmeD2UXdcPHeLXn+MwrCo7bKvi846PLUInai4peEywWyIf8ZFhdaLJ6Qcf7gJhurcOByE2CHA0JcTuYIy+petZj4ksQlaUqYf87bbr8CwpZmq3WXuXLnXJTY1hLO0DuE4KckaLxWC6h7Q=
Message-ID: <ba7d8f720802151312o643bae66p485287bc444103e9@mail.gmail.com>
Date: Fri, 15 Feb 2008 16:12:40 -0500
From: "Dan Upton" <upton.dan.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: accessing core temp sensors in the kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to do some work on thermally-aware scheduling, specifically
using the coretemp module to access core temperature sensors on the
Intel Core2 platform.  I know how to access them from user mode,
reading files from sysfs, but clearly that's not the way to do it in
the kernel.  Specifically, I'm not sure how, in the scheduler, to get
copies of the appropriate device structures to call

static struct coretemp_data *coretemp_update_device(struct device *dev)

(in hwmon/coretemp.c).

Can anybody give me pointers where to get started?

Thanks,
-dan
