Return-Path: <linux-kernel-owner+w=401wt.eu-S1762709AbXF1GaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762709AbXF1GaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 02:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758415AbXF1G37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 02:29:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:24684 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190AbXF1G37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 02:29:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YxqpJ0D5OAti3kU2RwlvNW77Td06VcbUgcpG4LlMYRC9fEkWuQLFJGdGrnDbbdJuTUHEr0m14oXsmQE7pv4Yzp7vrbEUIo1FdaShvxHlV0xVRbwaF8S75GHz0HX/EAyYjEJV5DFYAHylydZhXQwAa3zr0+k+0xDCN8YTZ7oqh8g=
Message-ID: <a8e1da0706272329j42997c3eh49a1b20df5892a0e@mail.gmail.com>
Date: Thu, 28 Jun 2007 06:29:54 +0000
From: "dave young" <hidave.darkstar@gmail.com>
To: "Josh Triplett" <josh@kernel.org>
Subject: Re: [PATCH] CodingStyle: Add information about trailing whitespace.
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Chris Shoemaker" <c.shoemaker@cox.net>,
       "Josh Triplett" <josht@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <46835047.8080600@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1182967160.8970.108.camel@josh-work.beaverton.ibm.com>
	 <20070627180552.GA746@pe.Belkin>
	 <Pine.LNX.4.64.0706280015320.11120@fbirervta.pbzchgretzou.qr>
	 <a8e1da0706272300q3aee30der5349e85055f62a8e@mail.gmail.com>
	 <46835047.8080600@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>2007/6/28, Josh Triplett <josh@kernel.org>:
> dave young wrote:
> > 2007/6/27, Jan Engelhardt <jengelh@computergmbh.de>:
> >> On Jun 27 2007 14:05, Chris Shoemaker wrote:
> >>> What I'd really like to see is, _why_ is trailing whitespace
> >>> considered harmful?
> >> Consumes bytes you'll never see :)
> >>
> >>> Something about MUAs not preserving it or something?
> >> Well, there is format=flowed. text/plain mails with a trailing blank at the end
> >> of line indicates the paragraph continues -- as a curtesy for mail readers with
> >> non-fixed-font to display the paragraph coherently rather than breaking it at
> >> 72/80 columns.
> >>
> >>
> >>         Jan
> >> --
> >> -
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >>
> >
> > There's more potential to cause  lines end with whitespace. How about
> > remove the "Some editors with ..."  like this :
> >
> > +Do not leave trailing whitespace at the ends of lines.
> > +
> [...]
>
> Many other causes for trailing whitespace exist.  However, I wanted to mention
> one of the common causes.  If you have other common causes in mind, and even
> better if you have ways to avoid them, we should add those too.
>
> It might make sense to put a paragraph break after the first sentence, though,
> and split the information about editors into its own paragraph, adding more
> paragraphs if people suggest other possibilities.
>

IMHO, another  cause of trailing whitespace is human error, for
example long lines breaking will easy to cause the first line with one
traling whitespace (original space between the last two words).

Regards
dave
