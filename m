Return-Path: <linux-kernel-owner+w=401wt.eu-S1760360AbYDKPFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360AbYDKPFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759476AbYDKPFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:05:01 -0400
Received: from depni.sinp.msu.ru ([213.131.7.21]:60596 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759078AbYDKPFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:05:01 -0400
X-Greylist: delayed 1311 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Apr 2008 11:05:01 EDT
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 5/7] PPS: serial clients support.
References: <20080410160630.GA24885@enneenne.com>
	<1207851751-25703-1-git-send-email-giometti@linux.it>
	<1207851751-25703-2-git-send-email-giometti@linux.it>
	<1207851751-25703-3-git-send-email-giometti@linux.it>
	<1207851751-25703-4-git-send-email-giometti@linux.it>
	<1207851751-25703-5-git-send-email-giometti@linux.it>
	<1207851751-25703-6-git-send-email-giometti@linux.it>
	<20080410210918.3be98868@core> <20080411075515.GH26777@enneenne.com>
	<20080411092840.3cc4de67@core> <20080411084903.GK26777@enneenne.com>
Date: Fri, 11 Apr 2008 18:43:07 +0400
In-Reply-To: <20080411084903.GK26777@enneenne.com> (Rodolfo Giometti's message
	of "Fri, 11 Apr 2008 10:49:03 +0200")
Message-ID: <87prsw78qs.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rodolfo Giometti <giometti@enneenne.com> writes:

> The problem is that deferencing the pps_event() call will cause severe
> problems to PPS accuracy... here you can find some considerations on
> this topic:
>
>    http://ml.enneenne.com/pipermail/linuxpps/2008-April/001738.html
>

What about adding precise timestamping to the lowest possible irq
handling level ( arch/*/entry*.S ) and then export that information
in a general way so it is useful for other applications?
