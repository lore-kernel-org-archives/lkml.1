Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbXFLNsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbXFLNsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 09:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756144AbXFLNsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 09:48:46 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:33394 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756138AbXFLNsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 09:48:45 -0400
Message-Id: <466EC08A.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 12 Jun 2007 15:49:30 +0200
From: "Jan Beulich" <jbeulich@novell.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Cc: "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Sam Ravnborg" <sam@ravnborg.org>, "Andi Kleen" <ak@suse.de>,
       <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: Re: [PATCH] x86: fix improper .init-type section references
References: <466E6BDF.76E4.0078.0@novell.com>
 <a781481a0706120414g385ccfe8j82b5b18d96d064f2@mail.gmail.com>
 <a781481a0706120509k89c331ela81f57ad0f0e29eb@mail.gmail.com>
 <466EB12B.76E4.0078.0@novell.com>
 <a781481a0706120632p54ad83d0ka0a07a9fd9b276b4@mail.gmail.com>
In-Reply-To: <a781481a0706120632p54ad83d0ka0a07a9fd9b276b4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> And from a purely theoretical
>> perspective I don't think such references should be considered bad -
>> .exit.* should be discarded together with .init.* if unloading is
>> impossible (built-in or configured off), not before module/kernel
>> initialization.
>
>Hmm, but that's not how things are, presently. __exit marked
>functions are simply not linked into the kernel (when that module
>is being built-in) at all -- this "discard" happens at _build time_
>(to save on kernel image size).

Not really, at least not for i386 and x86-64 - see their vmlinux.lds.S files.

Jan

