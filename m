Return-Path: <linux-kernel-owner+w=401wt.eu-S1762365AbYBNOLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762365AbYBNOLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 09:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbYBNOLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 09:11:15 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:56192 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbYBNOLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 09:11:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=EN8gEH71LlfMD5YOOF8QQNfLrzb8pqYWCpkHKRQCzFR+MUcAz1MZGEoqVlTNAORL42efEZqvjTfDz7H3QNmO7Ej9vUvBDFHsaVKyt6o/zTER9o5FL+0RArqUtT1mX79HLOLzbDO+qjUr9Idh71C+upVLnIe1TvSEupD3Bzk7cpE=
Message-ID: <2f11576a0802140611h261b9df2qd13406e562f52864@mail.gmail.com>
Date: Thu, 14 Feb 2008 23:11:12 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [RFC] bitmap relative operator for mempolicy extensions
Cc: "David Rientjes" <rientjes@google.com>, Lee.Schermerhorn@hp.com,
       mel@csn.ul.ie, ak@suse.de, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, clameter@sgi.com
In-Reply-To: <20080214123528.25274.84387.sendpatchset@jackhammer.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080214123528.25274.84387.sendpatchset@jackhammer.engr.sgi.com>
X-Google-Sender-Auth: 67265850e01cd513
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

>  The following adds one more bitmap operator, with the usual
>  cpumask and nodemask wrappers.  This operator computes one
>  bitmap relative to another.  If the n-th bit in the origin
>  mask is set, then the m-th bit of the destination mask will
>  be set, where m is the position of the n-th set bit in the
>  relative mask.

this patch is very interesting.

BTW:
Are you think this function name must be "relative" ?
I think "relative" implies ordered set.
but linux bitmap is abstraction of unordered set.
if possible, i prefer another name.

end up, bitmap_relative is map as pecial case, i think.

>  This is initially to be used by the MPOL_F_RELATIVE_NODES
>  facility being considered for mm/mempolicy.c.

agreed with node_relative idea.
I think this is very useful.

Thanks!
