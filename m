Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbYHTHB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbYHTHB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 03:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbYHTHBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 03:01:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288AbYHTHBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 03:01:17 -0400
Date: Wed, 20 Aug 2008 00:00:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Justin Mattock" <justinmattock@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: evdev.c(EVIOCGBIT): Suspicious buffer size 511,
Message-Id: <20080820000040.55015b48.akpm@linux-foundation.org>
In-Reply-To: <dd18b0c30808172310u7cf7836ai15e19485908ae0ce@mail.gmail.com>
References: <dd18b0c30808172310u7cf7836ai15e19485908ae0ce@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2008 23:10:54 -0700 "Justin Mattock" <justinmattock@gmail.com> wrote:

> I'm noticing:
> evdev.c(EVIOCGBIT): Suspicious buffer size 511, limiting output to 64
> bytes. See http://userweb.kernel.org/~dtor/eviocgbit-bug.html
> with rc-3 not with rc2.
> Did the patch to synaptics, seems
> my xorg is not reading /usr/X11R6/lib/modules/input/synaptics_drv.o
> only /usr/lib/xorg/modules/input/synaptics_drv.so
> is there any easy fix, or do I have to recompile xorg?
> regards;
> 

(cc's added)
