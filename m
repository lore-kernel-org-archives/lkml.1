Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbXITCY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbXITCY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 22:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbXITCYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 22:24:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43133 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750935AbXITCYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 22:24:51 -0400
Date: Wed, 19 Sep 2007 19:24:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dave Airlie" <airlied@gmail.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, "Jiri Slaby" <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
Message-Id: <20070919192439.ee31d68b.akpm@linux-foundation.org>
In-Reply-To: <21d7e9970709191842h3111390cl8f09745bed6bd8f9@mail.gmail.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<46F10B69.5070008@gmail.com>
	<46F10DCB.1090302@gmail.com>
	<46F13938.1070709@gmail.com>
	<20070919121017.0cbcbc30.akpm@linux-foundation.org>
	<20070919192453.GB18707@one.firstfloor.org>
	<21d7e9970709191842h3111390cl8f09745bed6bd8f9@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 11:42:29 +1000 "Dave Airlie" <airlied@gmail.com> wrote:

> From 225696d75e7ec0bafbb47b935bd700e3fbeefbde Mon Sep 17 00:00:00 2001
> From: Dave Airlie <airlied@redhat.com>
> Date: Thu, 20 Sep 2007 11:30:41 +1000
> Subject: [PATCH] agp: fix race condition between unmapping and freeing pages

This fixes the hang-when-quitting-X on the Vaio.
