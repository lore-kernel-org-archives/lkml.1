Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbZLDBxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbZLDBxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 20:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbZLDBxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 20:53:11 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:57005 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbZLDBxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 20:53:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=T7hm+o9RwoWvA5LxdbElEFMRnhaEzrMLiiPMjAexUVXsSLN9hKsvGfwmRualdX1YwP
         SpiRBKeUJeZvXCsO2o1qBHhpFhv2YDnhNuAk3wJpY3dmh3p9YMGi9eimhYLB+H/C7jJh
         5gPeWbnCzRSsySuQ2FXirXnkIIX6QYOozNF/o=
Date: Thu, 3 Dec 2009 20:53:11 -0500
From: Michael Gilbert <michael.s.gilbert@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: CVE-2004-2135 and CVE-2004-2136
Message-Id: <20091203205311.9a9478e4.michael.s.gilbert@gmail.com>
In-Reply-To: <20091203165321.GB6416@tatooine.rebelbase.local>
References: <20091202094539.c1184899.michael.s.gilbert@gmail.com>
	<20091203165321.GB6416@tatooine.rebelbase.local>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Dec 2009 17:53:21 +0100 markus reichelt wrote:
> * Michael Gilbert wrote:
> 
> > CVE-2004-2135 [0] and CVE-2004-2136 [1] were disclosed over five
> > years ago; however, i have been unable to verify whether they have
> > been fixed or not in the latest kernels.
> 
> They are not, and both CVE-entries are still marked as 'candidate'.
> Add the fact that (crypto)loop code has had a poor relation with the
> vanilla kernel in favour of dm-crypt, and is also unmaintained,
> nobody really cares.
> 
> Did you receive any other replies to your mail? Just curious.

None so far.  Would it make sense to remove cryptoloop at this point
since it obviously has some major design/implementation weaknesses?
Apropos, there are two other full-disk encryption options (dm-crypt and
loop-aes) that, importantly, are not affected by these issues. Is it
really a good idea to have three different implementations of
essentially the same functionality?

Best wishes,
Mike
