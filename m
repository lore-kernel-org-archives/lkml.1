Return-Path: <linux-kernel-owner+w=401wt.eu-S964813AbYBNBi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964813AbYBNBi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934800AbYBNBh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:37:58 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:37760 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934664AbYBNBh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:37:57 -0500
From: Roman Zippel <zippel@linux-m68k.org>
To: "Francis Moreau" <francis.moro@gmail.com>
Subject: Re: Question on timekeeping subsystem
Date: Thu, 14 Feb 2008 02:37:51 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com
References: <38b2ab8a0802130602r7d8fc470i7896e406d0451ec7@mail.gmail.com>
In-Reply-To: <38b2ab8a0802130602r7d8fc470i7896e406d0451ec7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802140237.51499.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 13. February 2008, Francis Moreau wrote:

> First I tried to find some documentation on the current implementation
> but haven't found any thing really usefull. Specially there's nothing about
> it in Documentation/ directory. Please correct me if I'm already wrong.
>
> Actually I read the implementation of update_wall_time() and I really fail
> to understand how it works. This is probably because I don't know
> what "xtime_nsec" and "error" fields in clocksource struct are for.
> These fields are not documented anywhere in the source code so it
> should be obvious but unfortunately not for me.

These mails should help to understand, what this code does:

http://lkml.org/lkml/2006/3/4/61
http://lkml.org/lkml/2006/4/3/205

bye, Roman
