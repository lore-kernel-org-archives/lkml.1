Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbXITO5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbXITO5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 10:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbXITO52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 10:57:28 -0400
Received: from mailout05.sul.t-online.de ([194.25.134.82]:37884 "EHLO
	mailout05.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754714AbXITO52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 10:57:28 -0400
Message-ID: <46F28A14.6050501@t-online.de>
Date: Thu, 20 Sep 2007 16:56:20 +0200
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070810)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, Bernd Schmidt <bernds_cb1@t-online.de>,
       David McCullough <David_Mccullough@securecomputing.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org, bryan.wu@analog.com,
       Bernd Schmidt <bernd.schmidt@analog.com>,
       Greg Ungerer <gerg@snapgear.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ysato@users.sourceforge.jp,
       miles.bader@necel.com, linux-m32r@ml.linux-m32r.org
Subject: Re: [PATCH] binfmt_flat: minimum support for theBlackfin relocations
References: <1190102965.4406.9.camel@roc-desktop> <200709192131.09469.rgetz@blackfin.uclinux.org> <20070920015525.GA16615@securecomputing.com> <20070920031807.GA31263@linux-sh.org> <46F261CA.50201@t-online.de> <20070920142543.GA3268@linux-sh.org>
In-Reply-To: <20070920142543.GA3268@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: EAryg2ZVwhC43XTTxrDLjFDM9yDAAKhJbbo5UXUe1nYWmPmHmTqWs7pXAuwalgdQkt
X-TOI-MSGID: fb4b2791-f003-47a5-a279-7fc8208b6200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> This is making API changes where it's convenient for your platform to use
> this value, and there's no reason to change the API here at all.

Your proposed addition of flat_validate_relval is an API change, and 
very similar in nature to what I've done.
A local variable here is the most natural way to store this information. 
  What do you suggest we use, a global?  A member in the task struct?

> Why should all architectures have to change their APIs (not just adding
> new things mind you, also changing existing definitions) to accomodate
> something that can trivially be kept in the blackfin code?

I don't see how there's a burden given that we've provided patches, and 
most maintainers have already said their fine with it.  It seems to me 
that it's a natural and common thing for many architectures to be 
updated when new things are added to core code.


Bernd
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif
