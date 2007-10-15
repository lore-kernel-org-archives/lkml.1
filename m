Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbXJOWM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbXJOWM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbXJOWMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:12:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:58896 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbXJOWMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:12:48 -0400
To: Stefan Monnier <monnier@iro.umontreal.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Killing a network connection
From: Andi Kleen <andi@firstfloor.org>
References: <jwvodf01b5i.fsf-monnier+gmane.linux.kernel@gnu.org>
Date: Tue, 16 Oct 2007 00:12:46 +0200
In-Reply-To: <jwvodf01b5i.fsf-monnier+gmane.linux.kernel@gnu.org> (Stefan Monnier's message of "Mon\, 15 Oct 2007 14\:40\:59 -0400")
Message-ID: <p73przg10yp.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Monnier <monnier@iro.umontreal.ca> writes:
>
> The main use for me is to deal with dangling connections due to taking
> network interfaces up&down with different IP addresses (typically the wlan0
> interface where the IP is different because I've modes from an AP to
> another).  Of course, maybe there's another way to solve this particular
> problem, in case I'd like to hear about it as well.

Long ago I did a 2.4 patch that solved exactly this problem. It introduced
a new ifconfig flag "dynamic" and when a dynamic address went down
all TCP connections originating from it were killed. It's still available
in older SUSE releases. I might post a forward port later.

-Andi
