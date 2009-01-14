Return-Path: <linux-kernel-owner+w=401wt.eu-S1760344AbZANVlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760344AbZANVlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754221AbZANVlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:41:35 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:23928 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbZANVle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:41:34 -0500
Subject: Re: [linux-dvb] compiling on 2.6.28 broken?
From: Chris Mason <chris.mason@oracle.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: wk <handygewinnspiel@gmx.de>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl, HWerner4@gmx.de,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mchehab@infradead.org
In-Reply-To: <496E5AB2.7040507@sandeen.net>
References: <20090112190420.51f75853@pedra.chehab.org>
	 <20090112132130.6c932b85.akpm@linux-foundation.org>
	 <20090112220624.4fbfee34@pedra.chehab.org>
	 <20090112162337.318dd61d.akpm@linux-foundation.org>
	 <20090113184755.87720@gmx.net>
	 <20090113105947.9e774b69.akpm@linux-foundation.org>
	 <20090113191757.74290@gmx.net>
	 <20090113113700.776a94b5.akpm@linux-foundation.org>
	 <20090113203843.GJ29283@parisc-linux.org>
	 <1231957750.8269.28.camel@think.oraclecorp.com> <496E56EB.2030301@gmx.de>
	 <1231968240.8269.48.camel@think.oraclecorp.com>
	 <496E5AB2.7040507@sandeen.net>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 16:40:21 -0500
Message-Id: <1231969221.8269.50.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.496E5BCA.0083:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 15:35 -0600, Eric Sandeen wrote:

> >> Attached the log from stracing the command which was ivoked by the 
> >> Makefile from v4l-dvb.
> >> I guess this is all i could contribute to that problem. Thats stuff for 
> >> xfs filesystem experts now..
> > 
> > Seems suspect indeed.  Could you please attach the strace for the run
> > that works on the older kernel?
> 
> Chris got my attention on this one; you probably want this fix from hch:
> 
> http://oss.sgi.com/archives/xfs/2009-01/msg00158.html
> 
> -Eric

Seems like this one should get queued for -stable as well if it isn't
already.

-chris


