Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbZJ0KV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbZJ0KV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 06:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbZJ0KVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 06:21:25 -0400
Received: from ns2.intersolute.de ([193.110.43.67]:38584 "EHLO
	ns2.intersolute.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbZJ0KVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 06:21:25 -0400
Message-ID: <4AE6C998.9040405@lumino.de>
Date: Tue, 27 Oct 2009 11:21:12 +0100
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Leonidas ." <leonidas137@gmail.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Noah Watkins <noah@noahdesu.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Difference between atomic operations and memory barriers
References: <f22d86810910261019yc77dbf0sa7688a98e7b98267@mail.gmail.com>	 <7ADB5FD7-9C97-4987-BC20-997258B25FD2@noahdesu.com>	 <f22d86810910261122j6c9e57e8pd4a257090f65c727@mail.gmail.com>	 <4AE5F1D2.9030908@s5r6.in-berlin.de> <f22d86810910261205r232db5d4re97a54827c7adab3@mail.gmail.com>
In-Reply-To: <f22d86810910261205r232db5d4re97a54827c7adab3@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leonidas . wrote:
> 
> any_t *ptr = something;
> 
> is always atomic even on SMPs without using locks, barriers then my
> doubt is cleared. Thanks.

I assume that this only holds if the pointer (not the thing it points
to) is denoted as volatile.

-Michael
