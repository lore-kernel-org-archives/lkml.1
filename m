Return-Path: <linux-kernel-owner+w=401wt.eu-S966068AbXDBXCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966068AbXDBXCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 19:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966025AbXDBXCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 19:02:40 -0400
Received: from ozlabs.org ([203.10.76.45]:46693 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966065AbXDBXCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 19:02:39 -0400
Subject: Re: [PATCH 1/5] Simplify module_get_kallsym() by dropping length
	arg
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: pmarques@grupopie.com, linux-kernel@vger.kernel.org, devel@openvz.org
In-Reply-To: <20070402150105.GA6735@localhost.sw.ru>
References: <20070402150105.GA6735@localhost.sw.ru>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 09:02:00 +1000
Message-Id: <1175554920.12230.445.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 19:01 +0400, Alexey Dobriyan wrote:
> -----------------------------------------------------------------------------
> [PATCH 1/5] Simplify module_get_kallsym() by dropping length arg
> 
> module_get_kallsym() could in theory truncate module symbol name to fit
> in buffer, but nobody does this. Always use KSYM_NAME_LEN + 1 bytes for name.
> 
> Suggested by lg^WRusty.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.


