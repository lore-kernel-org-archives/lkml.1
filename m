Return-Path: <linux-kernel-owner+w=401wt.eu-S1760548AbXGMAfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760548AbXGMAfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 20:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbXGMAfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 20:35:36 -0400
Received: from gw.goop.org ([64.81.55.164]:47594 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbXGMAff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 20:35:35 -0400
Message-ID: <4696C89E.4010002@goop.org>
Date: Thu, 12 Jul 2007 17:34:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <200707111916.35036.jesper.juhl@gmail.com>	 <2c0942db0707112159v3ee2cd83i74759c7138e273f7@mail.gmail.com> <9a8748490707121324q3b3e6e65ye14ab8e7f089d999@mail.gmail.com>
In-Reply-To: <9a8748490707121324q3b3e6e65ye14ab8e7f089d999@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> If, on the other hand, we consider 4K stacks to be the superior
> solution, then we should work to get all code fixed to be able to
> handle it so that it's actually something distros will start to enable
> so that we can eventually get rid of the 8K stack option alltogether.
> Making 4K stacks default and no longer a debug option is just the
> first step in that direction.

First step is to apply wli's patch which makes separate interrupt stacks 
orthogonal to the 4K stack option.

    J
