Return-Path: <linux-kernel-owner+w=401wt.eu-S1759176AbYJVVMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176AbYJVVMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYJVVMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:12:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:16808 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbYJVVMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:12:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=v1jc1+zEQB/WesQGiWh4hUhjXaF+YbCUbaPw2o0BqkBaWyjvR5pcHBJ+TpwU2zCAwb
         9h5UztZlmz/Q04QeQxKBgU9jCi7eRGnVctig8ARyL29+6SIrBdwPbzFbtHzwpF5cCzer
         dNPFo+bdWDQt3BY1Ql+j4+wKmrCqQxrPsbKFs=
Message-ID: <84144f020810221412uae54f1eudafa4c8fefea9753@mail.gmail.com>
Date: Thu, 23 Oct 2008 00:12:02 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: SLUB defrag pull request?
Cc: cl@linux-foundation.org, nickpiggin@yahoo.com.au, hugh@veritas.com,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <E1Ksksa-0002Iq-EV@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223883004.31587.15.camel@penberg-laptop>
	 <E1KsXrY-0000AU-C4@pomaz-ex.szeredi.hu>
	 <Pine.LNX.4.64.0810220822500.30851@quilx.com>
	 <E1Ksjed-00023D-UB@pomaz-ex.szeredi.hu>
	 <Pine.LNX.4.64.0810221252570.3562@quilx.com>
	 <E1Ksk3g-00027r-Lp@pomaz-ex.szeredi.hu>
	 <Pine.LNX.4.64.0810221315080.26671@quilx.com>
	 <E1KskHI-0002AF-Hz@pomaz-ex.szeredi.hu>
	 <84144f020810221348j536f0d84vca039ff32676e2cc@mail.gmail.com>
	 <E1Ksksa-0002Iq-EV@pomaz-ex.szeredi.hu>
X-Google-Sender-Auth: 95b7ad45be23e7bd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

On Thu, Oct 23, 2008 at 12:04 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> Actually, when debugging is enabled, it's customary to poison the
>> object, for example (see free_debug_processing() in mm/slub.c). So we
>> really can't "easily ensure" that in the allocator unless we by-pass
>> all the current debugging code.
>
> Thank you, that does actually answer my question.  I would still think
> it's a good sacrifice to no let the dentries be poisoned for the sake
> of a simpler dentry defragmenter.

To be honest, I haven't paid enough attention to the discussion to see
how much simpler it would be. But I don't like the idea of forcibly
disabling debugging for slab caches because of a new core feature in
the allocator. Keep in mind that it's not just dentries we're talking
about here, we're defragmenting inodes as well.

                        Pekka
