Return-Path: <linux-kernel-owner+w=401wt.eu-S1752077AbXJUXjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbXJUXjt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 19:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbXJUXjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 19:39:42 -0400
Received: from mx1.suse.de ([195.135.220.2]:37610 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbXJUXjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 19:39:41 -0400
From: Andreas Schwab <schwab@suse.de>
To: Frans Pop <elendil@planet.nl>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Why are ipmi modules being loaded?
References: <200710211534.11817.elendil@planet.nl>
	<20071021200936.GG32207@redhat.com>
	<200710212304.02990.elendil@planet.nl>
X-Yow: PARDON me, am I speaking ENGLISH?
Date: Mon, 22 Oct 2007 01:39:40 +0200
In-Reply-To: <200710212304.02990.elendil@planet.nl> (Frans Pop's message of
	"Sun\, 21 Oct 2007 23\:04\:02 +0200")
Message-ID: <jefy04m403.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop <elendil@planet.nl> writes:

> $ cat /sys/bus/pci/devices/0000\:01\:00.4/class
> 0x0c0701
>
> The last is close, but still does not match the 0x0c0700 in modules.pcimap. 
> Is there some fuzzy matching going on there?

The last byte (prog-if) is masked out: 0xffffff00.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
