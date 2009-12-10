Return-Path: <linux-kernel-owner+w=401wt.eu-S1761906AbZLJWIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761906AbZLJWIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 17:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761882AbZLJWId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 17:08:33 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:45941 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761777AbZLJWIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:08:32 -0500
Message-ID: <4B2170BB.2070001@nortel.com>
Date: Thu, 10 Dec 2009 16:05:47 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: jim owens <jowens@hp.com>, Randy Dunlap <rdunlap@xenotime.net>,
       linux-doc@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Dan Carpenter <error27@gmail.com>,
       Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] Documentation/email-clients.txt: clarify Thunderbird
 section
References: <4B210C6C.3060103@tuffmail.co.uk> <4B2110E3.8010508@hp.com> <4B2120F2.3090301@tuffmail.co.uk>
In-Reply-To: <4B2120F2.3090301@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2009 22:08:27.0063 (UTC) FILETIME=[4C741C70:01CA79E5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2009 10:25 AM, Alan Jenkins wrote:

> The RFC for format=flowed says that it should escape lines which start 
> with a space (by "space stuffing" - prepending an additional space).  So 
> in theory it should completely break patches.   And indeed it does 
> <http://gcc.gnu.org/ml/java-patches/2003-q2/msg00315.html>
> 
> Using HTML preformat in current versions of Thunderbird appears to send 
> with a format=flowed content-type, and then violates the RFC by not 
> performing any space-stuffing.
> 
> So if I look at format=flowed patch in my Sent email folder, I see that 
> the message viewer correctly strips the first leading space in each 
> line.  I.e. it breaks if you use copy+paste to get the patch out of 
> Thunderbird (or any other format=flowed aware client).  File->Save As 
> preserves the spaces though, allowing the patch to be applied.

Hmm...I'm using Thunderbird 3 beta4, and it appears that when sending
via the "preformat" mechanism it actually does perform space-stuffing.
This is visible as an extra leading space when looking at the raw source
of the sent (or received) email via ctrl-U.

However, if one turns off format=flowed, but leaves wrap set to 72, then
the html preformat works without having to set the wrap to 0.

Thanks,

Chris
