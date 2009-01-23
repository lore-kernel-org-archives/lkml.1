Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbZAWTse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbZAWTse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 14:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbZAWTs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 14:48:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:50251 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbZAWTsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 14:48:25 -0500
Message-ID: <497A1EDD.6070600@kernel.org>
Date: Fri, 23 Jan 2009 11:47:41 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Fwd: kernel panic when using disable_mtrr_trim [was: Re:	memory
 beyond4GB invisible to the system even though	CONFIG_HIGHMEM64G=y]]
References: <49763718.7010501@kernel.org> <86802c440901201249v3c877a88ie8e5f3bbf6abb871@mail.gmail.com> <49794422.2080109@kernel.org> <49797634.7040500@kernel.org> <4979771E.5050001@kernel.org> <49797788.2080603@kernel.org> <20090123092556.GC29820@elte.hu>
In-Reply-To: <20090123092556.GC29820@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>> Hmm... weird.  Can you please attach the .config file you used and the 
>>> commit ID and the version of toolchain?  I'll try to reproduce it 
>>> here.
> 
> Yinghai, please send the binutils package version too - if this is a 
> linker bug or linker interaction then it might matter.
> 
> GCC is 4.3.2 according to your boot log:
> 
>    (gcc version 4.3.2 [gcc-4_3-branch revision 141291] 

yhlu@linux-mstp:~> rpm -qa | grep binutils
binutils-2.19-9.3
binutils-devel-2.19-9.3


it is OpenSuse 11.1 x86_64 version

YH
