Return-Path: <linux-kernel-owner+w=401wt.eu-S932696AbXHNVKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbXHNVKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbXHNVJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:09:58 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:55625 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360AbXHNVJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:09:57 -0400
Date: Tue, 14 Aug 2007 23:09:56 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Hajime Inoue <hinoue@ccsl.carleton.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: System call interposition/unprotecting the table
In-Reply-To: <p73zm0tnbf8.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0708142308530.10912@fbirervta.pbzchgretzou.qr>
References: <20070813180535.vo36rcevi80s0c4c@www.ccsl.carleton.ca>
 <20070814000956.7c8929dd@the-village.bc.nu> <46C1E5F5.9050702@ccsl.carleton.ca>
 <p73zm0tnbf8.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 14 2007 21:50, Andi Kleen wrote:
>Hajime Inoue <hinoue@ccsl.carleton.ca> writes:
>
>> Just protecting the table does not stop rootkits.  A highly referenced
>> phrack article explains how to bypass the table. 
>
>During .23-pre for some time the kernel text was protected too (that
>would have likely stopped that particular attack), but it was
>removed because it caused too many problems.
>
>Ultimatively it is useless for security anyways because the page
>tables cannot be protected (because there are valid reasons to change
>them).

But with DEBUG_RODATA (does that also apply to .text?) enabled,
accidental writes to it should cause a fault rather than doing silent
changes, would not it?


	Jan
-- 
