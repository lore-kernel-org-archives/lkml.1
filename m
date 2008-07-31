Return-Path: <linux-kernel-owner+w=401wt.eu-S1752323AbYGaMW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbYGaMW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 08:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbYGaMWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 08:22:18 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:31244 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbYGaMWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 08:22:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DMQ5MiCh/ljggoLCQkRQOVmojaMGldPJE5waRhfFQ5i48v89ozWwslF8AiYCH63ln2
         ewOmTqj4Uw9PG13isPVjoPpnrl/xSs28FIyDvRZYRszfBFhEblT4/PvEbTc8kmOTZqE+
         JVhTIYJhzgTWIObtEqJ8L08d5buao4s+ACLpM=
Message-ID: <ef1cd66f0807310522j67d10fccm3ccc2cb7ebe51908@mail.gmail.com>
Date: Thu, 31 Jul 2008 13:22:17 +0100
From: "=?ISO-8859-1?Q?Jochen_Vo=DF?=" <jochen.voss@googlemail.com>
To: "Jonathan Corbet" <corbet@lwn.net>
Subject: Re: [PATCH, RFC] A development process document
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Amanda McPherson" <amanda@amcpherson.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080729143015.0f79cf37@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080729143015.0f79cf37@bike.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

Some more minor issues (disclaimer: I am not a native speaker of English).

2008/7/29 Jonathan Corbet <corbet@lwn.net>:
> +One of the most compelling features of Linux is that it is accessible to
> +these developers; anybody with the requisite skills can improve Linux and
> +influence the direction of its development.  Proprietary products cannot
> +offer this kind of openness, which is a characteristic of the free software
> +process.  But, if anything, the kernel is open even than most other free
> +software projects. ...

This last sentence looks strange to me.  Maybe a "more" is missing somehow?
[ I sent this one before, but forgot the proper Cc:s.  Sorry about that. ]

> +Years of experience with the kernel development community has taught a
> +clear lesson: ...
"have taught"?

> +5.5: SENDING THE PATCH
Maybe somewhere in this section say something about avoiding HTML
email and attachments?

> + - Signed-off-by: this is a developer's certification that he or she has
> +   the right to submit the patch for inclusion into the kernel.  It is an
> +   agreement to the Developer's Certificate of Origin, the full text of
> +   which can be found in SubmittingPatches.  Code without a proper signoff
> +   cannot be merged into the mainline.
Earlier you prefixed file names with "Documentation/".  Maybe do the
same here (and in the following paragraphs) for consistency?

> + - If you are responding to a bug report or a feature request, copy those
> +   people as well.
Maybe "the reporters" or similar instead of "those people"?

> +6.1: WORKING WITH REVIEWERS
> +
> +A patch of any significance will result in a number of comments from other
> +developers as they review the code.  Working with reviewers can be, for
> +many developers, the most indimidating part of the kernel development
"intimidating"

> +Excessive use of this capability can lead to other problems, though, beyond
> +a simple obsession for the creation of the perfect project history.
> +Rewriting history will rewrite the changes contained in that history,
> +turning a tested (hopefully) kernel tree into an untested one.  But, beyond
> +that, developers cannot easily collaborate if they do not have a shared
> +view of the project history; if you rewrite history which other developers
> +have pulled into their repositories, you will make life much more difficult
> +for those developers going forward. ...
Is the "going forward" meant to be there?

I hope this helps,
Jochen
-- 
http://seehuhn.de/
