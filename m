Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbZKLNXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbZKLNXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 08:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZKLNXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 08:23:47 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:53580 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbZKLNXq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 08:23:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=wMZSsrpfwtb9A5imbinLOcJ/JZcd6kwb2a7YkDZBoFagydJgTUj481Zn1Xeqke3Ios
         YePnshQ1jN2AMtSRB54EiKlTfuRlYlbGQHKMmuLE/OgsMWaxtCFJJiZLfDB333VHTzyr
         vnIjHLy/9D0N/TJXbWqQPWQQhsoHd4O41ODD0=
MIME-Version: 1.0
In-Reply-To: <200911122336.11033.rusty@rustcorp.com.au>
References: <cover.1257864802.git.andre.goddard@gmail.com> 
	<2bd27b061789ed14dd80816fd987273ae33ffbd1.1257864802.git.andre.goddard@gmail.com> 
	<200911122336.11033.rusty@rustcorp.com.au>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Thu, 12 Nov 2009 11:23:32 -0200
Message-ID: <b8bf37780911120523q79222fcdu6cb45997ab4b4e62@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] bsearch: prevent overflow when computing middle 
	comparison element
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: tabbott@ksplice.com, alan-jenkins@tuffmail.co.uk,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 11:06 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Wed, 11 Nov 2009 01:30:25 am André Goddard Rosa wrote:
>> It's really difficult to occur in practice because the sum of the lower
>> and higher limits must overflow an int variable, but it can occur when
>> working with large arrays. We'd better safe than sorry by avoiding this
>> overflow situation when computing the middle element for comparison.
>
> I applied all these, after testing.  In future would have been nice for you
> to have posted a test patch so I didn't have make my own...
>

Sure, no problem, thanks!

Kind regards,
André
