Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbYJ2VgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbYJ2VgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbYJ2VgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:36:13 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46906 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbYJ2VgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:36:12 -0400
Date: Wed, 29 Oct 2008 22:37:44 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] w35und: remove memcpy/memcmp wrappers
Message-ID: <20081029213743.GD1976@elf.ucw.cz>
References: <Pine.LNX.4.64.0810292010330.16596@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810292010330.16596@melkki.cs.Helsinki.FI>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-10-29 20:10:55, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> The OS_MEMORY_CLEAR macro is not used so remove it. Also convert the one
> call-site that uses OS_MEMORY_COMPARE to use memcmp() directly and remove the
> wrapper macro.
> 

Acked-by: Pavel Machek <pavel@suse.cz>


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
