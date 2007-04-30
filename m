Return-Path: <linux-kernel-owner+w=401wt.eu-S1031501AbXD3JcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031501AbXD3JcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 05:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031499AbXD3JcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 05:32:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:39809 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031493AbXD3JcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 05:32:06 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Tim Hockin <thockin@google.com>
Subject: Re: [PATCH] x86_64: support poll() on /dev/mcelog
Date: Mon, 30 Apr 2007 11:32:02 +0200
User-Agent: KMail/1.9.6
Cc: vojtech@suse.cz, linux-kernel@vger.kernel.org, akpm@google.com
References: <20070430022406.GA10158@google.com>
In-Reply-To: <20070430022406.GA10158@google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704301132.02814.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> -	
> +
> +	/* handle a waiting machine check */
> +retint_mce:

You could just handle it in notify_resume, no need to complicate
the assembler code

-Andi
