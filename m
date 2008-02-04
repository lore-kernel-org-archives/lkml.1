Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYBDA1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYBDA1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 19:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbYBDA1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 19:27:09 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:1425 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbYBDA1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 19:27:08 -0500
Date: Mon, 4 Feb 2008 01:27:05 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: section breakage on ppc64 (aka __devinitconst is broken by design)
Message-ID: <20080204002705.GA76428@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Al Viro <viro@ZenIV.linux.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
	linux-kernel@vger.kernel.org
References: <20080203130844.GS27894@ZenIV.linux.org.uk> <20080203172635.GA2275@uranus.ravnborg.org> <20080203180234.GT27894@ZenIV.linux.org.uk> <20080203203002.GD2648@uranus.ravnborg.org> <20080203210208.GU27894@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203210208.GU27894@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 09:02:08PM +0000, Al Viro wrote:
> On ppc64 relocs => r/w, AFAICS.  On other targets we might have any number
> of other rules.

And -fpic/PIC => (relocs => r/w) because of the DT_TEXTREL crap.  Not
of immediate interest to the kernel though.

  OG.
