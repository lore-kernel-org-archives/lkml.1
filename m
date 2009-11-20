Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbZKTOF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbZKTOF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 09:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbZKTOF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 09:05:28 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33973 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752283AbZKTOF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 09:05:28 -0500
Date: Fri, 20 Nov 2009 14:07:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Jan Beulich" <JBeulich@novell.com>
Cc: <Douglas_Warzecha@Dell.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] use proper address translation functions in Dell RBU
Message-ID: <20091120140722.6c579cac@lxorguk.ukuu.org.uk>
In-Reply-To: <4B06ABD602000078000211D5@vpn.id2.novell.com>
References: <4B06ABD602000078000211D5@vpn.id2.novell.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 13:46:46 +0000
"Jan Beulich" <JBeulich@novell.com> wrote:

> virt_to_bus() ought to be used (in particular for Xen compatibility).

This seems a bit odd - the addresses are memory physical addresses and
are accessed by the firmware not by external device logic. So I think
this is a Xen bug, the kernel code appears to be correct.

Alan


