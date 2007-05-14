Return-Path: <linux-kernel-owner+w=401wt.eu-S1760885AbXENXAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885AbXENXAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 19:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757653AbXENXAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 19:00:01 -0400
Received: from gw.goop.org ([64.81.55.164]:44133 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756092AbXENXAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 19:00:00 -0400
Message-ID: <4648E9EB.9010009@goop.org>
Date: Mon, 14 May 2007 15:59:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Frank Seidel <frank@kernalert.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Trivial string form cleanups
References: <200705150053.11606.frank@kernalert.de>
In-Reply-To: <200705150053.11606.frank@kernalert.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Seidel wrote:
> Change of string form like Jeff Garzik suggested
> it at http://janitor.kernelnewbies.org/TODO
> to get better assembly output as this format only
> declares a single variable.
>   

Saves sizeof(char *) per string too, but you need to be careful none of
these are being passed to sizeof or typeof.  Did you check for that in
your conversions?

    J
