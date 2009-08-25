Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbZHYTxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbZHYTxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085AbZHYTxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:53:20 -0400
Received: from claw.goop.org ([74.207.240.146]:49467 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756078AbZHYTxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:53:19 -0400
Message-ID: <4A944131.90908@goop.org>
Date: Tue, 25 Aug 2009 12:53:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Execute WP test after interrupts are enabled
References: <1251227779-24347-1-git-send-email-penberg@cs.helsinki.fi> <73c1f2160908251237i3d32b39eu8e198e56610d5724@mail.gmail.com>
In-Reply-To: <73c1f2160908251237i3d32b39eu8e198e56610d5724@mail.gmail.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/09 12:37, Brian Gerst wrote:
> Is there any reason to run this test at all on Xen?  It's only needed
> for real 386 and some broken 486 processors.
>   

Yeah.  We could easily set boot_cpu_data.wp_works_ok and bypass the
test, but I think its highlighting some other bug.

    J
