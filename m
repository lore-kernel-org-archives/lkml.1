Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbYIOGJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbYIOGJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 02:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbYIOGJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 02:09:23 -0400
Received: from gw.goop.org ([64.81.55.164]:37828 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbYIOGJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 02:09:23 -0400
Message-ID: <48CDFC10.8060906@goop.org>
Date: Sun, 14 Sep 2008 23:09:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: roberto@unbit.it
CC: Ingo Molnar <mingo@elte.hu>, jeremy@xensource.com,
       linux-kernel@vger.kernel.org, Mirko Iannella <mirko@unbit.it>,
       Alex Nixon <alex.nixon@citrix.com>
Subject: Re: [PATCH] xen: Fix for xen guest with mem > 3.7G
References: <1221333418.6036.9.camel@sirius> <48CC2C12.4080302@goop.org>	 <20080914132104.GB32106@elte.hu>  <48CD22CF.9030900@goop.org> <1221428593.6036.15.camel@sirius>
In-Reply-To: <1221428593.6036.15.camel@sirius>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roberto De Ioris wrote:
> In this way you pass a 64bit integer to the function, but max_pfn in
> origin is still 32bit.
>
> max_pfn need to be 64bit to supporto more than 4GB
>   

No, a 32-bit pfn (page frame number) is sufficient for 2^44 bytes of
memory.  Does this patch work for you?

    J
