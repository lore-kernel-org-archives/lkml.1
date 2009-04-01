Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbZDAF0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbZDAF0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 01:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZDAF0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 01:26:21 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:43631 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZDAF0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 01:26:21 -0400
Subject: Re: Linux 2.6.29
From: Bojan Smojver <bojan@rexursive.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1238538636.26693.11.camel@shrek.rexursive.com>
References: <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>
	 <20090326171148.9bf8f1ec.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>
	 <20090326174704.cd36bf7b.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain>
	 <20090327032301.GN6239@mit.edu> <20090327034705.GA16888@srcf.ucam.org>
	 <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org>
	 <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu>
	 <49CD4109.2070505@goop.org> <loom.20090328T073850-695@post.gmane.org>
	 <loom.20090328T084304-506@post.gmane.org>
	 <loom.20090328T214417-565@post.gmane.org>  <49D29077.80502@goop.org>
	 <1238538636.26693.11.camel@shrek.rexursive.com>
Content-Type: text/plain
Date: Wed, 01 Apr 2009 16:26:18 +1100
Message-Id: <1238563578.26693.19.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-01 at 09:30 +1100, Bojan Smojver wrote:
> I have no idea why we don't have that either. FreeBSD code seems
> really straightforward.

I just tried using dd with conv=fsync option and that kinda does what
you mentioned. I see this at the end of strace:
---------------------------------
write(1, "<some data...>"..., 512) = 512
read(0, ""..., 512)                = 0
fsync(1)                           = 0
close(0)                           = 0
close(1)                           = 0
---------------------------------

So, maybe GNU folks just don't want to have yet another tool for this.

-- 
Bojan

