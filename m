Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbYKJWoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbYKJWoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 17:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbYKJWoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 17:44:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50684 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbYKJWoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 17:44:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Smolik <marvin@mydatex.cz>
Subject: Re: [Bugme-new] [Bug 11886] New: without serial console system doesn't poweroff
Date: Mon, 10 Nov 2008 23:48:38 +0100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
References: <bug-11886-10286@http.bugzilla.kernel.org/> <200811090042.33219.rjw@sisk.pl> <4918B44A.6090104@mydatex.cz>
In-Reply-To: <4918B44A.6090104@mydatex.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811102348.39486.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 10 of November 2008, Daniel Smolik wrote:
[--snip--]
> I today test 2.6.26 and it works OK.

OK

Please check if this commit helps
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8d00450d296dedec9ada38d43b83e79cca6fd5a3

If not, the fastest way to find the failing commit would probably be to carry
out bisection of kernels between 2.6.26 (good) and 2.6.27 (presumably
bad as well as 2.6.27.2).
