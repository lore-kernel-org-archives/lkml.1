Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbXFMAVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbXFMAVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 20:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbXFMAVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 20:21:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428AbXFMAVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 20:21:43 -0400
Date: Tue, 12 Jun 2007 20:21:15 -0400
From: Dave Jones <davej@redhat.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix empty macros in acpi.
Message-ID: <20070613002115.GA28778@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Al Viro <viro@ftp.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070612233309.GA24251@redhat.com> <20070613000029.GK21478@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613000029.GK21478@ftp.linux.org.uk>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 01:00:29AM +0100, Al Viro wrote:
 > On Tue, Jun 12, 2007 at 07:33:09PM -0400, Dave Jones wrote:
 > > +#define DBG(x...) do { } while(0)
 > 
 > Eh...  Please, stop it - if you want a function-call-like no-op returning void,
 > use ((void)0).  At least that way one can say DBG(....),foo(), etc.

They both end up compiled to nothing anyway, so I'm not bothered
either way..   I'm not sure I follow why the syntax of that last part
is a good thing.  It looks like something we'd want to avoid rather
than promote?

	Dave

-- 
http://www.codemonkey.org.uk
