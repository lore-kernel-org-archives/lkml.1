Return-Path: <linux-kernel-owner+w=401wt.eu-S932931AbXLNCBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931AbXLNCBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 21:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760943AbXLNCBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 21:01:07 -0500
Received: from wr-out-0506.google.com ([64.233.184.235]:58122 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759694AbXLNCBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 21:01:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Gk2cWw2x03R+OuXSFnVYGLcmwje5jT41MhzSvWZ0De8YwTS5c+5CBCTm+sadmm3HmWehAJKDxxwAcM/uqJiTx36HaaZ539fIBi2YlNEbIQ5ztygG6CG5Eg37XNQEYYFRrHy6jid8L3n5WahLznk7QAGHTsjuUqPgNdxo1zpWbRg=
Message-ID: <9c9fda240712131801w5aec854eg71f3dc7ad49ddeb@mail.gmail.com>
Date: Fri, 14 Dec 2007 11:01:03 +0900
From: "Kyungmin Park" <kmpark@infradead.org>
To: "Pierre Ossman" <drzeus-list@drzeus.cx>
Subject: Re: [PATCH][MMC] Fix wrong EXT_CSD_REV handling
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071213092437.7aa2b928@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213071311.GA2970@party>
	 <20071213085332.18d2790d@poseidon.drzeus.cx>
	 <9c9fda240712130008s227a77dsbd9333c5227d51eb@mail.gmail.com>
	 <20071213092437.7aa2b928@poseidon.drzeus.cx>
X-Google-Sender-Auth: 44ad475f1634e31f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 13, 2007 5:24 PM, Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> On Thu, 13 Dec 2007 17:08:16 +0900
> "Kyungmin Park" <kmpark@infradead.org> wrote:
>
> >
> > In my MMC Spec. (v4.2), there's no problem to read it even though it's
> > revision 1.1
> >
>
> Well, the spec says that those reserved fields "should be zero". Unfortunately, people seem to have read this in the IETF sense and not as "the fields MUST be zero". I.e. I've seen cards where reserved fields contain junk.
>

Yes, reserved word should or must be zero, then it should check "if
(ext_csd_struct <= 2)" instead of ">= 2".
In the Spec. 4.2, it can have three value 0, 1, or 2. There's no other
restriction.

Thank you,
Kyungmin Park.
