Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbZKTOGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbZKTOGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 09:06:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbZKTOGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 09:06:03 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33977 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752895AbZKTOGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 09:06:02 -0500
Date: Fri, 20 Nov 2009 14:07:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Jan Beulich" <JBeulich@novell.com>
Cc: <Douglas_Warzecha@Dell.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] use proper address translation functions in DCDBAS
Message-ID: <20091120140757.5bd014e1@lxorguk.ukuu.org.uk>
In-Reply-To: <4B06ABA802000078000211D2@vpn.id2.novell.com>
References: <4B06ABA802000078000211D2@vpn.id2.novell.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 13:46:00 +0000
"Jan Beulich" <JBeulich@novell.com> wrote:

> In one case, the properly translated address is already available, in
> the other virt_to_bus() ought to be used (in particular for Xen
> compatibility).

Same again - these are physical CPU memory views so virt_to_bus is wrong.
