Return-Path: <linux-kernel-owner+w=401wt.eu-S1752940AbZKJLP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbZKJLP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbZKJLP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:15:58 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48115 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750912AbZKJLP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:15:58 -0500
Date: Tue, 10 Nov 2009 11:16:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: David Teigland <teigland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, rubini@vision.unipv.it,
       cluster-devel@redhat.com, device@lanana.org
Subject: Re: [Cluster-devel] Re: [PATCH] misc: use a proper range for minor
 number dynamic allocation
Message-ID: <20091110111637.44a4cb71@lxorguk.ukuu.org.uk>
In-Reply-To: <1257851408.6052.835.camel@localhost.localdomain>
References: <1256340497-19320-1-git-send-email-cascardo@holoscopio.com>
	<20091109132836.6cf7f559.akpm@linux-foundation.org>
	<20091109230311.GA820@redhat.com>
	<1257851408.6052.835.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If a change to the misc devices is planned, I'm wondering if it would be
> possible to merge some of the other functions into a single interface to

Three is not a problem but the original report is for a lot more - so
something funny is going on and that wants debugging first before
anything gets changed or name/number spaces allocated.

So LANANA firstly wants to know *why* the report is occuring and if the
whole issue is arising due to a bug in something not to a real need.

Alan
(with a LANANA hat on)
