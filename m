Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbYJBLaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbYJBLaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 07:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYJBL3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 07:29:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44666 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbYJBL3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 07:29:54 -0400
Message-ID: <48E4B07C.60605@redhat.com>
Date: Thu, 02 Oct 2008 14:29:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Jeremy Fitzhardinge <jeremy@goop.org>, akataria@vmware.com,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Daniel Hecht <dhecht@vmware.com>, Zach Amsden <zach@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors and	Linux.
References: <1222881242.9381.17.camel@alok-dev1> <48E3BBC1.2050607@goop.org> <1222894878.9381.63.camel@alok-dev1> <48E3E8DE.1080602@goop.org> <48E3ECD1.30809@codemonkey.ws> <20081001214338.GD634@sequoia.sous-sol.org>
In-Reply-To: <20081001214338.GD634@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> * Anthony Liguori (anthony@codemonkey.ws) wrote:
>   
>> And arguably, storing TSC frequency in CPUID is a terrible interface  
>> because the TSC frequency can change any time a guest is entered.  It  
>>     
>
> True for older hardware, newer hardware should fix this.  I guess the
> point is, the are numbers that are easy to measure incorrectly in guest.
> Doesn't justify the whole thing..
>   

It's not fixed for newer hardware.  Larger systems still have multiple 
tsc frequencies.

-- 
error compiling committee.c: too many arguments to function

