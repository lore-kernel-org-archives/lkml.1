Return-Path: <linux-kernel-owner+w=401wt.eu-S1753666AbYCQQ2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbYCQQ2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 12:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbYCQQ14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 12:27:56 -0400
Received: from [198.99.130.12] ([198.99.130.12]:40306 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbYCQQ1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 12:27:55 -0400
Date: Mon, 17 Mar 2008 12:27:04 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Nix <nix@esperi.org.uk>
Cc: clowncoder <vincent-perrier@club-internet.fr>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@timesys.com>
Subject: Re: [2.6.24.x] UML select()/poll() oversleeping reproducibly (was
	Re: [uml-devel] g_timeout_add)
Message-ID: <20080317162704.GA9536@c2.user-mode-linux.org>
References: <47B34BA0.30006@club-internet.fr> <20080214003853.GA15952@c2.user-mode-linux.org> <47B4BDCD.4080605@club-internet.fr> <20080215160205.GA6082@c2.user-mode-linux.org> <47B5CE40.9000005@club-internet.fr> <20080215184650.GA8810@c2.user-mode-linux.org> <87y78kx640.fsf_-_@hades.wkstn.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y78kx640.fsf_-_@hades.wkstn.nix>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 11:01:35PM +0000, Nix wrote:
> On a 1.4GHz Athlon IV using the tsc clocksource, I see consistent
> oversleeps, but not enormous ones:

> bash-3.2# ./select-sleep 10
> Slept for 13 seconds.

I'm seeing the same thing with tickless disabled on current UML - stay
tuned...

				Jeff

-- 
Work email - jdike at linux dot intel dot com
