Return-Path: <linux-kernel-owner+w=401wt.eu-S1752222AbYHaOzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbYHaOzJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 10:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbYHaOyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 10:54:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56159 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbYHaOyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 10:54:54 -0400
Message-ID: <48BAB074.50809@zytor.com>
Date: Sun, 31 Aug 2008 07:53:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Krzysztof Helt <krzysztof.h1@wp.pl>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] x86: amd k6-2 mtrr not detected fix
References: <20080831155828.d7dd0a76.krzysztof.h1@wp.pl>
In-Reply-To: <20080831155828.d7dd0a76.krzysztof.h1@wp.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Helt wrote:
> 
> It seems that the same problem affects Cyrix and
> Centaur/VIA cpus. Can some x86 guy inspect the
> mtrr initialization code ?
> 

*GROAN*

I would prefer if we could move the CPU detection code before the MTRR 
code; I don't think there is an inherent reason why we shouldn't be able 
to.  It would be much preferrable to scattering all kinds of CPU 
detection information all over the system.

I am going to be away today so I can't look at this myself until 
tomorrow at the earliest (tomorrow is a holiday here, though, so I can't 
promise I'll be around then either.)

	-hpa
