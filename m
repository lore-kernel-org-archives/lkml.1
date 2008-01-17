Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbYAQCDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbYAQCDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 21:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbYAQCDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 21:03:03 -0500
Received: from smtp-out.google.com ([216.239.33.17]:39283 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbYAQCDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 21:03:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=OMM8Xi1fD6U9YkjYTQKuhYbWXSAHsB2aP5R2wzr7vczKgFX+Og2sE1bKG5X+2YzCL
	ypANtupsWtrw8O3y8mRcg==
Message-ID: <4d47a5d10801161802x2c24ef59pf8422c8d14d487aa@mail.gmail.com>
Date: Wed, 16 Jan 2008 21:02:50 -0500
From: "Daniel Phillips" <phillips@google.com>
To: "Bryan Henderson" <hbryan@us.ibm.com>
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental fsck)
Cc: "Al Boldi" <a1426z@gawab.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "David Chinner" <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       "Pavel Machek" <pavel@ucw.cz>, "Rik van Riel" <riel@redhat.com>,
       "Theodore Tso" <tytso@mit.edu>, "Valerie Henson" <val.henson@gmail.com>
In-Reply-To: <OFDB679999.9793D1C7-ON882573D2.00646D05-882573D2.0068FF85@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4d47a5d10801151724m418e18efp9a0dd936e9a3584c@mail.gmail.com>
	 <OFDB679999.9793D1C7-ON882573D2.00646D05-882573D2.0068FF85@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 16, 2008 2:06 PM, Bryan Henderson <hbryan@us.ibm.com> wrote:
> >The "disk motor as a generator" tale may not be purely folklore.  When
> >an IDE drive is not in writeback mode, something special needs to done
> >to ensure the last write to media is not a scribble.
>
> No it doesn't.  The last write _is_ a scribble.

Have you observed that in the wild?  A former engineer of a disk drive
company suggests to me that the capacitors on the board provide enough
power to complete the last sector, even to park the head.

Regards,

Daniel
