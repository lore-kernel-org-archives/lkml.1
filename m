Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053AbZHRWbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbZHRWbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbZHRWbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:31:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49940 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751866AbZHRWbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:31:51 -0400
Date: Tue, 18 Aug 2009 23:32:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, Andries Brouwer <aeb@cwi.nl>
Subject: Re: completely hide parts of the partition table from Windows?
Message-ID: <20090818233256.3e378f46@lxorguk.ukuu.org.uk>
In-Reply-To: <19083.7062.710265.941247@pilspetsen.it.uu.se>
References: <19083.7062.710265.941247@pilspetsen.it.uu.se>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Any recommendations? If no existing partition table format is suitable
> for my use case then I'm perfectly willing to invent a simple new format
> and add the corresponding parser to the kernel.

Or if its not the boot partition can you not just tell device mapper about
it and create a device mapper device of the offset ?
