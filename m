Return-Path: <linux-kernel-owner+w=401wt.eu-S933476AbYEGTZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476AbYEGTZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761197AbYEGTYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:24:37 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:31406 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760016AbYEGTYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:24:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sL1mxjMRJfpH9IHGLli2RFzyd2zCeFCwfabP75N2oF1nAPKTIQ89vWIASLa2yvR2go4oDbFTvMHYmpEzKvuN+SXODvx1cwRF7orKN66oseJe6gfJgieitcM6XOBYNZCerlzzy7Mrhh87VUiTnt8polCQ11XepvckfR/hDVULCDQ=
Subject: Re: [PATCH 2/2] lib: vsprintf.c remove macros defining strict
	string functions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1210188046.19279.42.camel@brick>
References: <1210184729.19279.33.camel@brick>
	 <20080507200909.GB5131@martell.zuzino.mipt.ru>
	 <1210188046.19279.42.camel@brick>
Content-Type: text/plain
Date: Wed, 07 May 2008 12:24:17 -0700
Message-Id: <1210188257.19279.43.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-07 at 12:20 -0700, Harvey Harrison wrote:
> On Thu, 2008-05-08 at 00:09 +0400, Alexey Dobriyan wrote:
> > On Wed, May 07, 2008 at 11:25:29AM -0700, Harvey Harrison wrote:
> > > Directly code the strict string conversion functions rather than using
> > > defining macros.  Pull out a small helper to check the strict conditions
> > > required at the end of a string (nul-terminated or newline).
> > 
> > > Add additional checks in strict_strtol and strict_strtoll for numeric
> > > overflow of the signed types.
> > 
> > C interer ranges are asymmetric.
> 
> Yes, and LLONG_MAX = -LLONG_MIN + 1...so it will reject string values
> of LLONG_MIN...easily fixed if we want it I guess.


Missed the braces above obviously....but the point stands.

Harvey

