Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbYDDRxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbYDDRxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 13:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756586AbYDDRxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 13:53:15 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35293 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751734AbYDDRxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 13:53:14 -0400
Date: Fri, 4 Apr 2008 10:50:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ralf Baechle <ralf@linux-mips.org>
cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       dmitri.vorobiev@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm1 (mips build failure)
In-Reply-To: <Pine.LNX.4.64.0804041035350.16065@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0804041047010.16179@schroedinger.engr.sgi.com>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
 <47F31C46.9000503@gmail.com> <20080401230322.331c50f4.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0804021031480.26938@schroedinger.engr.sgi.com>
 <20080402112907.76e1c554.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0804021130040.28113@schroedinger.engr.sgi.com>
 <20080402190623.GA23651@uranus.ravnborg.org> <20080403160230.GA17771@linux-mips.org>
 <Pine.LNX.4.64.0804031515280.8986@schroedinger.engr.sgi.com>
 <20080404102407.GA25892@linux-mips.org> <Pine.LNX.4.64.0804041035350.16065@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008, Christoph Lameter wrote:

> Why would kbuild have to handle comments?

Ahh you want to insert comments into the generated 
include/asm-*/asm-offsets.h. Hmmm, the header comments state that it was 
generated so one would hopefully look at the source file instead ?

If we want comments etc in there then we may want to do in some 
standardized fashion that works across all arches. Most of the 
arch/*/asm-offsets.c contents are exactly the same. Mips is deviating the 
most. If we could put some of the common stuff into common header files 
then this may turn out to be a nice code cleanup.

