Return-Path: <linux-kernel-owner+w=401wt.eu-S1752972AbZKPNdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbZKPNdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 08:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbZKPNdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 08:33:42 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:4173 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZKPNdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 08:33:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=fdCKQOAMFZ1pbcfMa7rJ3O2K3tKAkm7QweWG8KGvKmBCTJ43oniMIALvrAqfUMGVOu
         1wJ1SLabM4m9Oe0uDwkAbAWUPXlbk7djD12113OXFWyJZqAfHWqqdEJx3fhem2cWdBcD
         4M3O9livfJ3Ly14vohXtD+bKawdvW1N5EVdQc=
MIME-Version: 1.0
In-Reply-To: <20091115175550.68964c72@taxman.wild-wind.fr.eu.org>
References: <20091115175550.68964c72@taxman.wild-wind.fr.eu.org>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 16 Nov 2009 21:33:27 +0800
Message-ID: <f17812d70911160533g175476ebraeaf7f56c48ac2cf@mail.gmail.com>
Subject: Re: [RFC][PATCH] Add interrupt handling capability to pca953x
To: Marc Zyngier <maz@misterjones.org>, David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linux Arm Kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 12:55 AM, Marc Zyngier <maz@misterjones.org> wrote:
> Most of the GPIO expanders controlled by the pca953x driver are
> able to report changes on the input pins through an *INT pin.
>
> This patch implements a very basic way for the platform code to
> be alerted when some input changes (both edge detection).
> It can be seen as a poor man irq_chip.
>
> Alternatively, this could be turned into a full-fledged irq_chip,
> though I'm not sure it is worth the complexity.
>

This actually has been submitted to the ML half a years ago along with
the first pca953x patch. I believe David Brownell has comments on
this, though :-)
