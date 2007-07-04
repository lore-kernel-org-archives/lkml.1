Return-Path: <linux-kernel-owner+w=401wt.eu-S1761555AbXGDNXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761555AbXGDNXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 09:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759351AbXGDNXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 09:23:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:46676 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758207AbXGDNXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 09:23:46 -0400
In-Reply-To: <20070704110719.GA11069@localhost.sw.ru>
References: <20070704110719.GA11069@localhost.sw.ru>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <1EC94CFE-EE04-455A-AE8C-573828DC5E37@kernel.crashing.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Content-Transfer-Encoding: 7bit
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] .gitignore update
Date: Wed, 4 Jul 2007 15:23:02 +0200
To: Alexey Dobriyan <adobriyan@sw.ru>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> headers_install by default puts headers into usr/include/ .
> They're auto-generated, so should be ignored.
>
> Same for *.orig, *.rej .

If you have .orig or .rej files hanging around, it means you
have an unresolved merge conflict.  Better not ignore it.


Segher

