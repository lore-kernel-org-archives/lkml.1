Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbXKVCQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbXKVCQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 21:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbXKVCQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 21:16:48 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:50868 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbXKVCQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 21:16:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Xp1fLHpNAmT7Ysq33TP68HLUiqsAiM4UXy/DuZDjJ61DK1jYGUGNHKOlN43ebNZm9tPajOr4R4pOXDRW+eF+GyWvIOt1kRARBA8fyXDSwfs3297bP1Svc/0aKykR0u9jRzrcVgcQXTe+Su7wf9MRqPi/zaejlIBPSnAmTVCeWu8=
Message-ID: <9a8748490711211816g5df5a81age77ad28c7382a11b@mail.gmail.com>
Date: Thu, 22 Nov 2007 03:16:45 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Al Niessner" <Al.Niessner@jpl.nasa.gov>
Subject: Re: Where is the interrupt going?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1195693710.5544.240.camel@morte.jpl.nasa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1195693710.5544.240.camel@morte.jpl.nasa.gov>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/11/2007, Al Niessner <Al.Niessner@jpl.nasa.gov> wrote:
>
> Quickly stated, I have a piece of hardware on the PCI bus that is
> generating an interrupt (can watch it with a scope) but my handler is
> not being called (no printk in /var/log/messages). So, where has the
> interrupt gone?
>
Just to rule out the trivial causes. Could it be that you've simply
not configured your system to log messages at the loglevel that your
printk() is using?

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
