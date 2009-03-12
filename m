Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbZCLSKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbZCLSKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 14:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbZCLSKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 14:10:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53711 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752467AbZCLSKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 14:10:33 -0400
Date: Thu, 12 Mar 2009 18:09:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Markus Armbruster <armbru@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       "xen-devel\@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Ian Jackson <Ian.Jackson@eu.citrix.com>,
       Anders Kaseorg <andersk@MIT.EDU>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] IRQ handling race and spurious IIR read in
 serial/8250.c
Message-ID: <20090312180955.1f52a401@lxorguk.ukuu.org.uk>
In-Reply-To: <874oxyei9k.fsf@pike.pond.sub.org>
References: <874oxyei9k.fsf@pike.pond.sub.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ian Jackson recently debugged a problem reported by Anders Kaseorg, and
> posted a fix (see http://lkml.org/lkml/2009/2/11/240).  As far as I can
> see, the patch has been dropped on the floor.

It was proposed as a band aid fix not a real fix. The real fix involves
finishing sorting out any locking issues Ian identified. I've not seen a
patch for that yet.
