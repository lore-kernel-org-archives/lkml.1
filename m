Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbZA0MYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbZA0MYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 07:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbZA0MYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 07:24:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41326 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbZA0MYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 07:24:32 -0500
Date: Tue, 27 Jan 2009 10:24:21 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: LINUX NEWBIE <lnxnewbie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: cx88 audio input change
Message-ID: <20090127102421.06bfd4c1@caramujo.chehab.org>
In-Reply-To: <55fdf7050901261409h67f581f1ib6951ecb60eb8e8@mail.gmail.com>
References: <55fdf7050901261409h67f581f1ib6951ecb60eb8e8@mail.gmail.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 26 Jan 2009 14:09:31 -0800
LINUX NEWBIE <lnxnewbie@gmail.com> wrote:

> Hi Mauro,
> 
>     You've been working on cx88 for a long time.  Can I ask you
> something?  I have a cx88 based card and I tried to get audio coming
> from "Line In" of my card.  However, it seems like the audio always
> comes from TV input.   I looked into the code and it seems like
> VIDIOC_S_AUDIO is not working in cx88.  Can you help please?

The better is to ask such questions on linux-media@vger.kernel.org. Anyway, the
issue is likely due to a wrong entry at cx88-cards for your board. In order to
fix, someone with your board (probably you)should get the proper GPIO pins for
your device. Please read the following wiki articles:

http://linuxtv.org/wiki/index.php/Development:_How_to_add_support_for_a_device
http://linuxtv.org/wiki/index.php/GPIO_pins

Cheers,
Mauro
