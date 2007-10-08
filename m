Return-Path: <linux-kernel-owner+w=401wt.eu-S1752271AbXJHOSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbXJHOSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 10:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbXJHOSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 10:18:40 -0400
Received: from mail.suse.de ([195.135.220.2]:48712 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbXJHOSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 10:18:40 -0400
To: "Joerg Roedel" <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, "Christoph Egger" <christoph.egger@amd.com>
Subject: Re: [PATCH] i386: some MCE cleanups
References: <11918519193283-git-send-email-joerg.roedel@amd.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 08 Oct 2007 16:18:37 +0200
In-Reply-To: <11918519193283-git-send-email-joerg.roedel@amd.com>
Message-ID: <p73wstx4rlu.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Joerg Roedel" <joerg.roedel@amd.com> writes:

> MCG_CAP never reports a negative count of available error-reporting
> banks. Make it unsigned.
> Check for MCA/MCE feature bits as early as possible.  While here, do an
> indent cleanup.

Never mix style cleanups with other changes. It makes it near impossible
to review anything.

-Andi
