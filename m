Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbZGBWQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbZGBWQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 18:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZGBWQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 18:16:15 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:31519 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752006AbZGBWQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 18:16:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xC7tTgQAUmgZLHzK8ER9XuCu5HHfjw/CBiEn1b174MxfhCzBN7ITuvZGRleMXtZZ7q4tD73TiVgZW1korOhHizVxUH56+cpBirjRKmmWzuS50/BwVzGR/PsNBC+XFC7zD7YU91tL0WQlR6hMCIkP028s+/SUJehIqhoZBfUjw/c=  ;
X-YMail-OSG: MORG6DUVM1nljZqHsTfjgGpo1LtYMVahIv5vOizVNMCk89kohwtD_13okvEzuRZcfOnC3sTsGGhBTdTQmz4dKsWi4ATeVl_4MxqQusFnQVeWKiTUUvQmDYx8mY07XhCoggO0rCgrE4Nq1MYo49v9MPdvA3rIHM4TziNID_y34YldpCz5zI5Rm4T2XcK0OegilE_LqMpeKX9AeWtroqvDcd6vn2ZwS6KyIDCPe1odldNEqYfNG1suV9zU5lUvrz3bBUBjspWGPrY_wVaa
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Subject: Re: [PATCH v2] gpiolib: allow poll(2) on gpio value
Date: Thu, 2 Jul 2009 15:16:17 -0700
User-Agent: KMail/1.9.10
Cc: Daniel =?iso-8859-1?q?Gl=F6ckner?= <dg@emlix.com>,
       Ben Nizette <bn@niasdigital.com>, linux-kernel@vger.kernel.org
References: <1244212590-15620-1-git-send-email-dg@emlix.com> <200907021157.33250.david-b@pacbell.net> <359ed6810907021437m4417d4bfhc3d49b19387dbf96@mail.gmail.com>
In-Reply-To: <359ed6810907021437m4417d4bfhc3d49b19387dbf96@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907021516.17510.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 July 2009, Jani Nikula wrote:
> I'm trying to say that if you call gpio_export() to create a sysfs
> node, a subsequent poll() in user space won't work because there is no
> irq set up, and sysfs_notify_dirent() won't be called. The patch
> doesn't provide an interface for setting that up from kernel after
> gpio_export() call - it's only possible to set up edge triggering and
> sysfs notify by writing to the "edge" node from user space.

OK, now I understand.  :)

Yeah, that seems fixable in followups.
