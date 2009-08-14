Return-Path: <linux-kernel-owner+w=401wt.eu-S1755694AbZHNDFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbZHNDFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 23:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbZHNDFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 23:05:00 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:52290 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbZHNDE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 23:04:59 -0400
Subject: Re: [PATCH] amd5536udc: fixed shared interrupt bug and warning oops
From: Vadim Lobanov <vlobanov@speakeasy.net>
To: Thomas Dahlmann <dahlmann.thomas@arcor.de>
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
In-Reply-To: <1250028056.14854.18.camel@pc>
References: <1250028056.14854.18.camel@pc>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 20:04:56 -0700
Message-Id: <1250219096.2653.1.camel@leonidas>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 00:00 +0200, Thomas Dahlmann wrote:
> >From 9654f85cbeabec4b8652f9785bea317cd7068edb Mon Sep 17 00:00:00 2001
> From: Thomas <dahlmann.thomas@arcor.de>
> Date: Tue, 11 Aug 2009 22:09:55 +0200
> Subject: [PATCH] amd5536udc: fixed shared interrupt bug and warning oops
>   - fixed shared interrupt bug reported by Vadim Lobanov
>   - fixed possible warning oops on driver unload when connected
>   - prevent interrupt flood in PIO mode ("modprobe amd5536udc use_dma=0")
>     when using gadget ether
>   - applied patch "Drop NULL test on list_entry result" submitted by Julia Lawall
> 
> Signed-off-by: Thomas <dahlmann.thomas@arcor.de>

Looks good.

Tested-by: Vadim Lobanov <vlobanov@speakeasy.net>


