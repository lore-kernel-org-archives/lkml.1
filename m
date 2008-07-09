Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbYGIRJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbYGIRJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 13:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbYGIRJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 13:09:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbYGIRJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 13:09:47 -0400
Date: Wed, 9 Jul 2008 13:03:07 -0400
From: Dave Jones <davej@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: scripts/gcc-x86_64-has-stack-protector.sh missing ?
Message-ID: <20080709170307.GC29961@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
References: <20080709155844.GB29961@redhat.com> <20080709163557.GA1277@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709163557.GA1277@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 06:35:57PM +0200, Sam Ravnborg wrote:
 > On Wed, Jul 09, 2008 at 11:58:44AM -0400, Dave Jones wrote:
 > > I just did a 'make tags' on a fresh checkout of Linus' tree, and got this..
 > > 
 > > /bin/sh: /mnt/data/src/git-trees/kernel/linux-2.6/scripts/gcc-x86_64-has-stack-protector.sh: No such file or directory
 > > 
 > > arch/x86/Makefile references this, but it seems to not be in the tree.
 > 
 > Added by:
 > 4f7fd4d7a79193ceda4ce77f75e22917d33fa154

Spooky. not sure what I screwed up, but a fresh git checkout fixed it.

thanks,

	Dave

-- 
http://www.codemonkey.org.uk
