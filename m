Return-Path: <linux-kernel-owner+w=401wt.eu-S933075AbXB0QZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075AbXB0QZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 11:25:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbXB0QZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 11:25:12 -0500
Received: from smtp.ono.com ([62.42.230.12]:49913 "EHLO resmaa04.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751856AbXB0QZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 11:25:10 -0500
Date: Tue, 27 Feb 2007 17:24:17 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: "remi.chateauneu@gmail.com" <remi.chateauneu@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: list.h , list_head and C++
Message-ID: <20070227172417.0364fc5f@werewolf-wl>
In-Reply-To: <45E44165.4060608@shaw.ca>
References: <1172493644.311389.243780@8g2000cwh.googlegroups.com>
	<fa.K8OHlwttPU4TDDzMegRRFAIJrxw@ifi.uio.no>
	<fa.9RVekJKqUMy1lb5hfYQYDK8VxnE@ifi.uio.no>
	<1172571563.228792.208610@h3g2000cwc.googlegroups.com>
	<45E44165.4060608@shaw.ca>
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Feb 2007 08:34:13 -0600, Robert Hancock <hancockr@shaw.ca> wrote:

> remi.chateauneu@gmail.com wrote:
> > On Feb 26, 2:26 pm, Robert Hancock <hanco...@shaw.ca> wrote:
> >> remi.chateau...@gmail.com wrote:
> >>> My C++ program needs an intrusive list, possibly with RCU
> >>> capabilities.The data structurelist_head, defined in /usr/include/
> >>> linux/list.h , fits perfectly these needs.

In userspace you're better thinking of a STL list protected by some
POSIX threads primitives. Depending on what you really want to do
with the list, for example a shared work queue, you
could look into condition variables or rwlocks.
Use the standard STL list. You will save a lot of work. And they are not
so bad in performance.

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.19-jam07 (gcc 4.1.2 20070115 (prerelease) (4.1.2-0.20070115.1mdv2007.1)) #2 SMP PREEMPT
