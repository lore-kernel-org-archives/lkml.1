Return-Path: <linux-kernel-owner+w=401wt.eu-S1760082AbZATOym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082AbZATOym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 09:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbZATOy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 09:54:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:52351 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540AbZATOy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 09:54:29 -0500
Subject: Re: why usr/include/linux/if_frad.h is required
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: mike.mclagan@linux.org
Cc: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       netdev@vger.kernel.org, davem@davemloft.net,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1232463174.3088.15.camel@localhost.localdomain>
References: <1232463174.3088.15.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 20:24:02 +0530
Message-Id: <1232463242.3088.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: LKML

On Tue, 2009-01-20 at 20:23 +0530, Jaswinder Singh Rajput wrote:
> For if_frad.h I am getting two warnings with 'make headers_check':
>   usr/include/linux/if_frad.h:29: leaks CONFIG_DLCI to userspace where it is not valid
>   usr/include/linux/if_frad.h:129: leaks CONFIG_DLCI to userspace where it is not valid
> 
> Almost all if_frad.h is covered with #if defined(CONFIG_DLCI) || defined(CONFIG_DLCI_MODULE) 
> 
> If I remove this portion so only this what we get in userspace:
> 
> #ifndef _FRAD_H_
> #define _FRAD_H_
> 
> #include <linux/if.h>
> 
> #endif
> 
> So I am surprising what is the point of this ? 
> 
> Can I change its name to is_fraud ;-)
> 
> --
> JSR

