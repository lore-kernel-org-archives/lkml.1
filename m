Return-Path: <linux-kernel-owner+w=401wt.eu-S1762424AbZD3NMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762424AbZD3NMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757104AbZD3NMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:12:46 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:1047 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468AbZD3NMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:12:45 -0400
X-Greylist: delayed 627 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Apr 2009 09:12:45 EDT
Date: Thu, 30 Apr 2009 15:02:12 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Valdis.Kletnieks@vt.edu, Martin Knoblauch <knobi@knobisoft.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org,
       tigran aivazian <tigran@aivazian.fsnet.co.uk>
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
Message-ID: <20090430130212.GA54591@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Al Viro <viro@ZenIV.linux.org.uk>, Valdis.Kletnieks@vt.edu,
	Martin Knoblauch <knobi@knobisoft.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Galbraith <efault@gmx.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-kernel@vger.kernel.org,
	tigran aivazian <tigran@aivazian.fsnet.co.uk>
References: <409142.83316.qm@web32605.mail.mud.yahoo.com> <20090428182837.62c51f26.akpm@linux-foundation.org> <1240977096.5478.3.camel@marge.simson.net> <20090429011755.c141c599.akpm@linux-foundation.org> <20090429120827.GI8633@ZenIV.linux.org.uk> <884894.99151.qm@web32602.mail.mud.yahoo.com> <30441.1241026559@turing-police.cc.vt.edu> <20090429174323.GL8633@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429174323.GL8633@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 06:43:23PM +0100, Al Viro wrote:
> Again, the interesting question is WTF had mount(2) not failed with -EBUSY

A change of '/' between the two mounts maybe?  If one is done from
initrd and the other after / is mounted?

  OG.

