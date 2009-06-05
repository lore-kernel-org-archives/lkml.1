Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbZFESAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbZFESAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbZFESA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:00:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53163 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753634AbZFESA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:00:26 -0400
Date: Fri, 5 Jun 2009 19:01:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: lkml@morethan.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Compile Warning] 2.6.30-rc8 build
Message-ID: <20090605190138.5ac32f94@lxorguk.ukuu.org.uk>
In-Reply-To: <200906051143.06119.lkml@morethan.org>
References: <200906051143.06119.lkml@morethan.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009 11:43:03 -0500
"Michael S. Zick" <lkml@morethan.org> wrote:

> Group,
> 
> To my reading of the function, I think gcc has a point:
> 
> drivers/serial/8250.c: In function 'serial8250_shutdown':
> drivers/serial/8250.c:1685: warning: 'i' may be used uninitialized in this function
> 
> It does read as if the code might try to initialize
> the 'lock' field of a null pointer.
> 
> Suggestions?

Newer gcc ? At least current gcc appears to correctly deduce the code is
safe.

Alan
