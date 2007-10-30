Return-Path: <linux-kernel-owner+w=401wt.eu-S1757985AbXJ3U3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbXJ3U3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbXJ3U3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:29:47 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:27611 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbXJ3U3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:29:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jfM+6ZkQwd1xOG7P+WVOJXo45JKf811HPMDAepSo2/K4HnMNi26NPsjynG+4Wwd018HueYUFk2vwIHWcKIDMX11JjUhjms1QhaJGGeb1TqmnQiEqRo+zQQQB1eRLsRM0pn491gDyw/WxbdaUzzK4H5vWK+cXJUTScyfOP7/Y7AM=
Message-ID: <8bd0f97a0710301329i8a21b22ncc9f71a81bc06543@mail.gmail.com>
Date: Tue, 30 Oct 2007 16:29:45 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 00/14] Blackfin on-chip SPI controller driver updates and bug-fixing
Cc: "Bryan Wu" <bryan.wu@analog.com>, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <200710301324.07691.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
	 <200710301324.07691.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/07, David Brownell <david-b@pacbell.net> wrote:
> And also, pay closer attention to when you may be making
> changes that make device drivers work differently over
> your spi_master controller driver than anyone elses ...
> such platform-specific behaviors are undesirable, and when
> they go against specified behavior they are also bugs.

was there something that caught your eye other than the ugly udelay()
you mentioned in the other thread ?
-mike
