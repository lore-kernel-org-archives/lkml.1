Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbZKMPDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbZKMPDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 10:03:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbZKMPDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 10:03:00 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:56481 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872AbZKMPC7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 10:02:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XCRblaDwjoipmHPKiW/jzNyEdmJuuxDvA+XaWBP6ftXJrUOu00RtXRgHy5tytaIUYP
         HQ3PdcQROewQxyDa1inlZZJYbYKJ6ND2mZci7uhjYTafkULFZ6w+5cH2mMh7VjoWA5vz
         RhsZGY3T5CPhMXA3cUcvIg1v3yXqn5Xaw7P8k=
MIME-Version: 1.0
In-Reply-To: <200911122336.11033.rusty@rustcorp.com.au>
References: <cover.1257864802.git.andre.goddard@gmail.com>
	 <2bd27b061789ed14dd80816fd987273ae33ffbd1.1257864802.git.andre.goddard@gmail.com>
	 <200911122336.11033.rusty@rustcorp.com.au>
Date: Fri, 13 Nov 2009 13:03:04 -0200
Message-ID: <a4c8a6d00911130703v44dcb920h81a41378ec7b026b@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] bsearch: prevent overflow when computing middle 
	comparison element
From: Thiago Farina <tfransosi@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: =?UTF-8?Q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>,
       tabbott@ksplice.com, alan-jenkins@tuffmail.co.uk,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Thu, Nov 12, 2009 at 11:06 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Wed, 11 Nov 2009 01:30:25 am André Goddard Rosa wrote:
>> It's really difficult to occur in practice because the sum of the lower
>> and higher limits must overflow an int variable, but it can occur when
>> working with large arrays. We'd better safe than sorry by avoiding this
>> overflow situation when computing the middle element for comparison.
>
> I applied all these, after testing.  In future would have been nice for you
> to have posted a test patch so I didn't have make my own...

Where did you apply this patch?
