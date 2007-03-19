Return-Path: <linux-kernel-owner+w=401wt.eu-S1030683AbXCSVur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030683AbXCSVur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030624AbXCSVtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:49:01 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:18833 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030591AbXCSVs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:48:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ezN6QfE2zJvUP8Q5H5JnWeB/cqXnTpkzV5hhSzQLH91X3GwnMGtXpzpLRN+936C68+rJfCVyWwXTnsndCcGQ2as0QuwRlI+5FC1KQHszOy7VSt3UihhTaqvkyy7TwbUYqnX+XkrdyCbq2lRwDEcU37b3wi81LMO2RPmHCRP0GNs=
Message-ID: <d120d5000703191448m67c1afcnc3340c956ef7a25a@mail.gmail.com>
Date: Mon, 19 Mar 2007 17:48:55 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [patch 29/31] Input: i8042 - fix AUX IRQ delivery check
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       "Greg KH" <greg@kroah.com>, "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20070319214108.GE9261@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070319213047.710101653@mini.kroah.org>
	 <20070319213647.GB9261@kroah.com> <20070319214108.GE9261@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/19/07, Greg KH <gregkh@suse.de> wrote:
> -stable review patch.  If anyone has any objections, please let us know.
>
> ------------------
>
> From: Dmitry Torokhov <dtor@insightbb.com>
>
> Input: i8042 - fix AUX IRQ delivery check
>
> On boxes that do not implement AUX LOOP command we can not
> verify AUX IRQ delivery and must assume that it is wired
> properly.
>

Greg,

There is another piece missing in AUX delivery test, commit

    3ca5de6dd4ec5a139b2b8f00dce3e4726ca91af1

Unfortunately I can't send you a patch at the moment but if you could
get it from the mainline that would be great.

-- 
Dmitry
