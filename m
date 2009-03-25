Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbZCYBFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbZCYBFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 21:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbZCYBFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 21:05:30 -0400
Received: from ozlabs.org ([203.10.76.45]:40123 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755700AbZCYBF3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 21:05:29 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: =?iso-8859-1?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: [Patch] kernel/module.c: fix an unused goto label
Date: Wed, 25 Mar 2009 11:35:23 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
References: <20090324160719.GE9686@hack>
In-Reply-To: <20090324160719.GE9686@hack>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903251135.24073.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 March 2009 02:37:19 Américo Wang wrote:
> 
> Label 'free_init' is only used when defined(CONFIG_MODULE_UNLOAD) &&
> defined(CONFIG_SMP), so move it inside to shut up gcc.

Thanks, applied!
Rusty.
