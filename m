Return-Path: <linux-kernel-owner+w=401wt.eu-S1761701AbZDCUxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761701AbZDCUxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755863AbZDCUx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:53:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:59984 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336AbZDCUxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:53:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nGGcW1uYSoVnu8J0pcWg1WHbxTczS0OZM+iunAyIeSRhzHy2Wl0jn9cn2u/R8TECMl
         PF7gmNvN/4Vm2o8ekA6hAe604SZTyldNYVac6mZO9jnN70BJw/xq0dMYIrhSNRI7WCG8
         KePovSJkKn2qq1OHPekZru1AeBUyE1Mu1XpPM=
MIME-Version: 1.0
In-Reply-To: <20090331153223.74b177bd@skybase>
References: <20090331153223.74b177bd@skybase>
Date: Fri, 3 Apr 2009 13:53:24 -0700
Message-ID: <6934efce0904031353x3323e2c3g87723c1881e95c1c@mail.gmail.com>
Subject: Re: [PATCH] do_xip_mapping_read: fix length calculation
From: Jared Hulbert <jaredeh@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Carsten Otte <cotte@de.ibm.com>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This bug is the cause for the heap corruption Carsten has been chasing
> for so long:

Finally saw this issue on ARM.  Some programs in Android on ARM were
crashing with AXFS.  This fixed it.
