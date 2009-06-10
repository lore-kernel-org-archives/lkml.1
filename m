Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbZFJH04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbZFJH04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 03:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648AbZFJH0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 03:26:49 -0400
Received: from ozlabs.org ([203.10.76.45]:34615 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338AbZFJH0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 03:26:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: rr tree build failure
Date: Wed, 10 Jun 2009 16:56:46 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090609201205.2894522c.sfr@canb.auug.org.au>
In-Reply-To: <20090609201205.2894522c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906101656.48204.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009 07:42:05 pm Stephen Rothwell wrote:
> Hi Rusty,
>
> Today's linux-next build (powerpc allnoconfig) failed like this:
>
> lib/extable.c: In function 'trim_init_extable':
> lib/extable.c:50: error: dereferencing pointer to incomplete type
> lib/extable.c:50: error: implicit declaration of function
..
> This is a build without CONFIG_MODULE.

Ah, my bad.  I'll wrap this and test this config too.

Thanks,
Rusty.


