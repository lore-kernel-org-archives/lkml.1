Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbZG0MAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbZG0MAL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 08:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbZG0MAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 08:00:11 -0400
Received: from relay.atmel.no ([80.232.32.139]:64736 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbZG0MAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 08:00:10 -0400
Date: Mon, 27 Jul 2009 13:54:51 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, nicolas.ferre@atmel.com,
       hskinnemoen@atmel.com, kvm <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [FIX REQUEST] Need better management for include/linux/*.h
Message-ID: <20090727135451.0754ba6e@hskinnemoen-d830>
In-Reply-To: <4A599820.9030905@redhat.com>
References: <1247303928.2678.46.camel@ht.satnam>
	<4A599820.9030905@redhat.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> IMO a much better move is to place non-ABI files (and the #ifdef KERNEL 
> parts of ABI files) outside include/linux.

How about adding a new include/soc directory and move them all there
(along with similar header files from other SoC vendors)?

Haavard
