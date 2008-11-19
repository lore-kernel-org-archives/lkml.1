Return-Path: <linux-kernel-owner+w=401wt.eu-S1752377AbYKSAMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbYKSAMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 19:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbYKSAMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 19:12:07 -0500
Received: from ozlabs.org ([203.10.76.45]:37551 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbYKSAMG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 19:12:06 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: =?iso-8859-1?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: [Patch] MODULE_UNLOAD should depend on PROC_FS
Date: Wed, 19 Nov 2008 10:41:53 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
References: <20081118184052.GA24453@hack.voiplan.pt>
In-Reply-To: <20081118184052.GA24453@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811191041.53716.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 November 2008 05:10:52 Américo Wang wrote:
> The feature controlled by MODULE_UNLOAD uses proc interface, so it
> should depend on PROC_FS.

Hi Wang,

   This patch looks wrong to me; you can remove modules without /proc.  Does 
it not compile with CONFIG_MODULE_UNLOAD=y and CONFIG_PROC_FS=n?

Thanks,
Rusty.

