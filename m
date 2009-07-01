Return-Path: <linux-kernel-owner+w=401wt.eu-S1753694AbZGAFWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbZGAFWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 01:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbZGAFW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 01:22:28 -0400
Received: from ozlabs.org ([203.10.76.45]:36965 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbZGAFW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 01:22:27 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Jan Beulich" <JBeulich@novell.com>
Subject: Re: [PATCH] also discard .*init sections after module initialization
Date: Wed, 1 Jul 2009 14:52:26 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: sam@ravnborg.org, tony.luck@intel.com,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Paul Mackerras" <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Tim Abbott <tabbott@mit.edu>
References: <4A4A19C60200007800008353@vpn.id2.novell.com>
In-Reply-To: <4A4A19C60200007800008353@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907011452.26720.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 09:27:26 pm Jan Beulich wrote:
> Just like .init, these sections are supposed to be unneeded after init,
> and modpost warns about improper section references anyway.

Tim Abbot had a section renaming patch, for -ffunction-sections.  Can we kill 
two birds with one stone and have a unique string for init sections, and 
another for exit sections?

> Likewise
> for .*exit which, other than .exit, aren't needed for the module unload
> path.

Currently true, but I can't see that being true in general.

If we're going to abstract init detection, it would be good to wrap init 
section renaming (for powerpc64 at least) too.

Thanks,
Rusty.
