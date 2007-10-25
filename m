Return-Path: <linux-kernel-owner+w=401wt.eu-S1758991AbXJYSgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991AbXJYSgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbXJYSgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:36:16 -0400
Received: from gw.goop.org ([64.81.55.164]:44068 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbXJYSgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:36:16 -0400
Message-ID: <4720E1F9.4020700@goop.org>
Date: Thu, 25 Oct 2007 11:35:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com
Subject: Re: [PATCH] Wipe out traditional opt from x86_64 Makefile
References: <11933164723812-git-send-email-gcosta@redhat.com> <20071025173605.GM30533@stusta.de> <4720D8EA.1090501@zytor.com> <20071025183055.GN30533@stusta.de>
In-Reply-To: <20071025183055.GN30533@stusta.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Sorry for the dumb question, but how does or did the gcc -traditional 
> option affect ld?
>   

vmlinux.lds is run through cpp (as a .S file).

    J
