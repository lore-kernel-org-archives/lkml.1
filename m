Return-Path: <linux-kernel-owner+w=401wt.eu-S1751459AbXBVIJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbXBVIJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 03:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbXBVIJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 03:09:05 -0500
Received: from gw.goop.org ([64.81.55.164]:51726 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbXBVIJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 03:09:03 -0500
Message-ID: <45DD4FA0.5030205@goop.org>
Date: Thu, 22 Feb 2007 00:09:04 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -freg-struct-return?
References: <45DCF1C5.4030006@goop.org> <1172131463.3531.226.camel@laptopd505.fenrus.org>
In-Reply-To: <1172131463.3531.226.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Do we know how many gcc bugs this has? (regparm used to have many)
> other than that.. sounds like a win...
>   

The documentation suggests that its the preferred mode of operation, and
that its the default on platforms where gcc is the primary compiler.  So
the fact that it isn't for Linux suggests either an oversight or that it
is actually broken...

Do we have much assembler which cares about the struct return calling
convention?  If not, it should be a fairly easy test.

    J
