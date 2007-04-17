Return-Path: <linux-kernel-owner+w=401wt.eu-S1031247AbXDQRiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031247AbXDQRiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031238AbXDQRiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:38:15 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:50268 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031247AbXDQRiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:38:14 -0400
Subject: Re: [PATCH] Show slab memory usage on OOM and SysRq-M (v2)
From: Dave Hansen <hansendc@us.ibm.com>
To: Pavel Emelianov <xemul@sw.ru>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eric Dumazet <dada1@cosmosbay.com>, Linux MM <linux-mm@kvack.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
In-Reply-To: <4624E8F4.2090200@sw.ru>
References: <4624E8F4.2090200@sw.ru>
Content-Type: text/plain
Date: Tue, 17 Apr 2007 10:37:53 -0700
Message-Id: <1176831473.12599.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-17 at 19:34 +0400, Pavel Emelianov wrote:
> +#define SHOW_TOP_SLABS 10 

Real minor nit on this one: SHOW_TOP_SLABS sounds like a bool.  "Should
I show the top slabs?"

This might be a bit more clear:

#define TOP_NR_SLABS_TO_SHOW 10 

or

#define NR_SLABS_TO_SHOW 10

-- Dave

