Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbXLGKtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbXLGKtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 05:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbXLGKtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 05:49:11 -0500
Received: from mail.suse.de ([195.135.220.2]:36291 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbXLGKtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 05:49:10 -0500
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Robert Hancock <hancockr@shaw.ca>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
From: Andi Kleen <andi@firstfloor.org>
References: <fa./27SNSh+L5T3iqFNPdHClEu+yT0@ifi.uio.no>
	<4758927F.50500@shaw.ca> <4758D584.90105@keyaccess.nl>
Date: Fri, 07 Dec 2007 11:49:08 +0100
In-Reply-To: <4758D584.90105@keyaccess.nl> (Rene Herman's message of "Fri\, 07 Dec 2007 06\:09\:24 +0100")
Message-ID: <p73y7c6ixuj.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman <rene.herman@keyaccess.nl> writes:
>
> If there are no sensible fixes, an 0x80/0xed choice could I assume be
> hung of DMI or something (if that _is_ parsed soon enough).

Another possibility would be to key this off DMI year (or existence
of DMI year since old systems don't have it). I guess it would
be reasonable to not do any delays on anything modern.

On x86-64 it could be presumably always disabled too, although
I was always too chicken to do that.

-Andi
