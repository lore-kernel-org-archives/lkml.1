Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYJAVpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYJAVpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 17:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbYJAVox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 17:44:53 -0400
Received: from sous-sol.org ([216.99.217.87]:60526 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752389AbYJAVow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 17:44:52 -0400
Date: Wed, 1 Oct 2008 14:43:38 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, akataria@vmware.com,
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
Message-ID: <20081001214338.GD634@sequoia.sous-sol.org>
References: <1222881242.9381.17.camel@alok-dev1> <48E3BBC1.2050607@goop.org> <1222894878.9381.63.camel@alok-dev1> <48E3E8DE.1080602@goop.org> <48E3ECD1.30809@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E3ECD1.30809@codemonkey.ws>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anthony Liguori (anthony@codemonkey.ws) wrote:
> And arguably, storing TSC frequency in CPUID is a terrible interface  
> because the TSC frequency can change any time a guest is entered.  It  

True for older hardware, newer hardware should fix this.  I guess the
point is, the are numbers that are easy to measure incorrectly in guest.
Doesn't justify the whole thing..
