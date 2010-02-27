Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967905Ab0B0Hwi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 02:52:38 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:52117 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967879Ab0B0Hwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 02:52:37 -0500
X-Auth-Info: HnVJe1KdXXO1VxjuqyswU49UOJMs3f6QXEs4d+S6p9A=
Date: Sat, 27 Feb 2010 08:52:01 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexander Shishkin <virtuoso@slind.org>,
       Valentin Sitdikov <valentin.sitdikov@siemens.com>,
       Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH] obsolete config in kernel source (LWMON5)
Message-ID: <20100227085201.0096f801@wker>
In-Reply-To: <20100205134256.GB7077@faui49.informatik.uni-erlangen.de>
References: <20100205134256.GB7077@faui49.informatik.uni-erlangen.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Feb 2010 14:42:57 +0100
Christoph Egger <siccegge@stud.informatik.uni-erlangen.de> wrote:

> 	LWMON5 is a larger chunk from the kategory unreachable and
> here for ever. Seems this board was either only available from
> external trees or has been removed a long time ago. If you agree it
> might be worth removing it.

The LWMON5 board port existed for arch/ppc which was removed
entirely in 2.6.27. So, it is ok to apply this patch.

> ----
> From 8334822cc79b4cf0b7f6844ebd952ebb24ee046f Mon Sep 17 00:00:00 2001
> From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
> Date: Fri, 5 Feb 2010 13:49:13 +0100
> Subject: [PATCH] Remove conditionalizing on LWMON5
> 
> There was some condigionalizing for the LWMON5 boards in kernel
> source. However infrastructure for enabling this isn't here so
> probably the special case code can go as well.
> 
> Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>

Acked-by: Anatolij Gustschin <agust@denx.de>
