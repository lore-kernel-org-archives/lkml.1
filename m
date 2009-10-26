Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbZJZVyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbZJZVyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZJZVyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:54:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48803
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752794AbZJZVyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:54:05 -0400
Date: Mon, 26 Oct 2009 14:54:28 -0700 (PDT)
Message-Id: <20091026.145428.127892659.davem@davemloft.net>
To: raysonlogin@gmail.com
Cc: mouse@mayc.ru, linux-kernel@vger.kernel.org
Subject: Re: FatELF & patents
From: David Miller <davem@davemloft.net>
In-Reply-To: <73a01bf20910261059j74bb37a9td472efc21c5440ca@mail.gmail.com>
References: <73a01bf20910260850v215385e6q2cbbf9133acd5e1e@mail.gmail.com>
	<4AE5C7C0.3060305@mayc.ru>
	<73a01bf20910261059j74bb37a9td472efc21c5440ca@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rayson Ho <raysonlogin@gmail.com>
Date: Mon, 26 Oct 2009 12:59:22 -0500

> The patent mentions only one prior art:
> 
> "One prior art attempt to provide a method for providing a single
> application for a variety of architectures and formats is the ANDF
> system, developed by OSF. This is an architecture neutral binary
> format. A disadvantage of this scheme is that it requires conversion
> to the native architecture at installation time."
> 
> I don't think there is anything similar to Apple's fat binary or
> universal binary -- a single executable that can be executed on
> different processor families.

A variant of the Sparc SILO boot loader, called TILO, was
doing this with Sparc Linux kernel images 15 or so years ago.

It packs a 32-bit and a 64-bit Linux kernel into one blob and figures
out which one to actually boot once it figures out what kind of
machine it is executing on.
