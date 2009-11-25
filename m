Return-Path: <linux-kernel-owner+w=401wt.eu-S934598AbZKYR7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934598AbZKYR7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759414AbZKYR7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:59:23 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52245 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758837AbZKYR7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:59:23 -0500
Date: Wed, 25 Nov 2009 18:01:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/86] PATA fixes
Message-ID: <20091125180118.66053387@lxorguk.ukuu.org.uk>
In-Reply-To: <4B0D6735.8000604@garzik.org>
References: <20091125170218.5446.13513.sendpatchset@localhost>
	<4B0D6735.8000604@garzik.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summary would be lots of really good stuff and review.

> hmmmm....  will reserve comment until I review it thoroughly, but I am a 
> bit reluctant to move away from the current struct-driver style driver 
> init/setup model.

I think the model is right - I'd prefer it to be in the driver structs
somewhere but the basic point that init and resume often do the same job
is a very sound one.
