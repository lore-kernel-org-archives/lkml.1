Return-Path: <linux-kernel-owner+w=401wt.eu-S1751717AbXEBFRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbXEBFRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbXEBFRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:17:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:65300 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbXEBFRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:17:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=QxXh+PjjzkR3n3PBSbcDuOaWYdtRCTuaVYbnTlX54tWAsJXEaIxuzfwosyi5pMeCZTT8z7bn4W+LDeKtfF0Ce7qOyWUVzPcjsbEXSclup4q8wPx1JMX6t6Xmh3n75+AcBdu7ttUmAk00Wl9vJOxW6K5i/X52/QgN478DZ1qoLG8=
Date: Wed, 2 May 2007 09:17:23 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
Message-ID: <20070502051723.GB5843@martell.zuzino.mipt.ru>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 09:28:18PM -0700, David Rientjes wrote:
> +#define __attribute_unused__		__attribute__((unused))

Suggest __unused which is shorter and looks compiler-neutral.

