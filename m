Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107Ab0AGNLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab0AGNLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 08:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690Ab0AGNLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 08:11:40 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39948 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab0AGNLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 08:11:40 -0500
Date: Thu, 7 Jan 2010 07:54:33 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Justin Mattock <justinmattock@gmail.com>
Cc: linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [bisected] sys_paccept: disable paccept() causes my macbook
	pro to have an annoying whining sound
Message-ID: <20100107125433.GB13603@tuxdriver.com>
References: <dd18b0c31001062216m316163f4t992c000eca0f76d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd18b0c31001062216m316163f4t992c000eca0f76d@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 10:16:27PM -0800, Justin Mattock wrote:
> for a while I've been hearing this odd
> annoying sound coming from my macbook pro
> when the system is idle(no internet use tv/radio/web etc...)
> as soon as I do anything(radio,web) the noise disappears.
> 
> here is a  url where they are experiencing the same issue:
> https://help.ubuntu.com/community/MacBook1-1/Hardy
> (down under whining noise);
> 
> here is is the result of my bisect:
> 
> 2d4c8266774188cda7f7e612e6dfb8ad12c579d5 is the first bad commit
> commit 2d4c8266774188cda7f7e612e6dfb8ad12c579d5
> Author: Michael Kerrisk <mtk.manpages@googlemail.com>
> Date:   Mon Sep 22 13:57:49 2008 -0700
> 
>     sys_paccept: disable paccept() until API design is resolved

Any particular reason you sent this to linux-wireless??

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
