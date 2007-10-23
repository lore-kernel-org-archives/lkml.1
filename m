Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbXJWDmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbXJWDmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 23:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbXJWDl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 23:41:58 -0400
Received: from [198.99.130.12] ([198.99.130.12]:59330 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbXJWDl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 23:41:57 -0400
Date: Mon, 22 Oct 2007 23:41:18 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, miklos@szeredi.hu,
       linux-kernel@vger.kernel.org, xemul@openvz.org, raven@themaw.net
Subject: Re: futex strangeness in 2.6.23-mm1/UML
Message-ID: <20071023034118.GA12504@c2.user-mode-linux.org>
References: <E1Ik15P-0001wg-00@dorka.pomaz.szeredi.hu> <20071022145321.195d929b@bree.surriel.com> <E1Ik4Ch-000273-00@dorka.pomaz.szeredi.hu> <20071022172926.03ca122a@bree.surriel.com> <20071022200742.6f3acbb2@bree.surriel.com> <20071022171624.0c00f8da.akpm@linux-foundation.org> <20071022211143.5f69d790@bree.surriel.com> <20071022213812.32bdac03@bree.surriel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022213812.32bdac03@bree.surriel.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 09:38:12PM -0400, Rik van Riel wrote:
> Wrt. the UML failures that Miklos is seeing, I imagine UML needs
> to do some similar tricks.

UML is just an architecture - it has no need of such tricks (although
it does need to keep track of host pids, but these are in architecture
data, invisible to the rest of the kernel).

				Jeff

-- 
Work email - jdike at linux dot intel dot com
