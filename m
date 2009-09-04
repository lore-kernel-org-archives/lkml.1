Return-Path: <linux-kernel-owner+w=401wt.eu-S1757041AbZIDQLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041AbZIDQLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbZIDQLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:11:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46754 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbZIDQLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:11:51 -0400
Message-ID: <4AA13C10.4040802@zytor.com>
Date: Fri, 04 Sep 2009 09:10:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: consolidate boot/compressed/Makefile's list of	
 targets
References: <4AA0E74C02000078000136F0@vpn.id2.novell.com>
In-Reply-To: <4AA0E74C02000078000136F0@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2009 01:09 AM, Jan Beulich wrote:
> Impact: cleanup
> 
> Rather than (inconsistently) having some target specifications
> scattered around and some listed at the top of the file, list them all
> in one place. And make use of suffix-y to reduce the list's length.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 

I had been meaning to get around to cleaning this up, but this is IMNSHO
completely backwards.  Distributing targets so that all the stuff that
produces a particular file is in one place is IMO a much cleaner style.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

