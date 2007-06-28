Return-Path: <linux-kernel-owner+w=401wt.eu-S1760355AbXF1GA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355AbXF1GA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 02:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbXF1GAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 02:00:15 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:51866 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbXF1GAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 02:00:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=t6H+1DHrVrrBl++Zwp4Scqy6m6xIIVLrQBewNAOnoTUP2xZdB1HKAS6Gcgq3XbRIAG6ddXspdxQSAQf9jDu/awHf4PCQZc1WJjrSRjQCpodMsK8vYzJdMczOADkTe1EON/sreiEu0YnQuyFTsunOI04aXLRn7efuED/wSdEudJk=
Message-ID: <a8e1da0706272300q3aee30der5349e85055f62a8e@mail.gmail.com>
Date: Thu, 28 Jun 2007 06:00:12 +0000
From: "dave young" <hidave.darkstar@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [PATCH] CodingStyle: Add information about trailing whitespace.
Cc: "Chris Shoemaker" <c.shoemaker@cox.net>,
       "Josh Triplett" <josht@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       josh@kernel.org
In-Reply-To: <Pine.LNX.4.64.0706280015320.11120@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1182967160.8970.108.camel@josh-work.beaverton.ibm.com>
	 <20070627180552.GA746@pe.Belkin>
	 <Pine.LNX.4.64.0706280015320.11120@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/6/27, Jan Engelhardt <jengelh@computergmbh.de>:
>
> On Jun 27 2007 14:05, Chris Shoemaker wrote:
> >
> >What I'd really like to see is, _why_ is trailing whitespace
> >considered harmful?
>
> Consumes bytes you'll never see :)
>
> >Something about MUAs not preserving it or something?
>
> Well, there is format=flowed. text/plain mails with a trailing blank at the end
> of line indicates the paragraph continues -- as a curtesy for mail readers with
> non-fixed-font to display the paragraph coherently rather than breaking it at
> 72/80 columns.
>
>
>         Jan
> --
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

There's more potential to cause  lines end with whitespace. How about
remove the "Some editors with ..."  like this :

+Do not leave trailing whitespace at the ends of lines.
+
+Git will warn you about patches that introduce trailing whitespace, and can
+optionally strip the trailing whitespace for you; however, if applying a series
+of patches, this may make later patches in the series fail by changing their
+context lines.
+
