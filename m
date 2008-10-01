Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbYJAVR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbYJAVR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 17:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbYJAVRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 17:17:47 -0400
Received: from sous-sol.org ([216.99.217.87]:51928 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753974AbYJAVRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 17:17:46 -0400
Date: Wed, 1 Oct 2008 14:15:32 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: akataria@vmware.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Daniel Hecht <dhecht@vmware.com>, Zach Amsden <zach@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors and
	Linux.
Message-ID: <20081001211532.GC634@sequoia.sous-sol.org>
References: <1222881242.9381.17.camel@alok-dev1> <48E3BBC1.2050607@goop.org> <1222894878.9381.63.camel@alok-dev1> <48E3E6DF.8060400@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E3E6DF.8060400@codemonkey.ws>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anthony Liguori (anthony@codemonkey.ws) wrote:
> We've already gone down the road of trying to make standard paravirtual  
> interfaces (via virtio).  No one was sufficiently interested in  
> collaborating.  I don't see why other paravirtualizations are going to  
> be much different.

The point is to be able to support those interfaces.  Presently a Linux guest
will test and find out which HV it's running on, and adapt.  Another
guest will fail to enlighten itself, and perf will suffer...yadda, yadda.

thanks,
-chris
