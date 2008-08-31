Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbYHaRhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbYHaRhD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 13:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbYHaRgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 13:36:54 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:15584 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbYHaRgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 13:36:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dKFGdWFibi0ixGhg5srWtPEr/EzDTngTAmpUu8pLbx3z3p0AN5KxwQzvbjJqyA7jpL
         wE109RnWLppr6OCOcz2qyCNKxSto539KNI0PsPUPzSlsBxeB9JpxRezQmazSM825BnyY
         ggSc6an3LMyIb55+M3ncVVcbsrOBxiA/96pI0=
Message-ID: <91b13c310808311036k2792d1fqaeb94a814f0bee81@mail.gmail.com>
Date: Mon, 1 Sep 2008 01:36:51 +0800
From: "rae l" <crquan@gmail.com>
To: "Ross S. W. Walker" <RWalker@medallion.com>
Subject: Re: [Iscsitarget-devel] [RFC] future IET development
Cc: "Arne Redlich" <agr@powerkom-dd.de>,
       iscsitarget-devel <iscsitarget-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, unh-iscsi-checkins@lists.sourceforge.net
In-Reply-To: <E2BB8074E5500C42984D980D4BD78EF9022A73D4@MFG-NYC-EXCH2.mfg.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218829367.3145.31.camel@blackadder>
	 <91b13c310808282007u7fc90eeah2b27661a7a5f595@mail.gmail.com>
	 <E2BB8074E5500C42984D980D4BD78EF9022A73D4@MFG-NYC-EXCH2.mfg.prv>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 10:38 PM, Ross S. W. Walker
<RWalker@medallion.com> wrote:
> rae l wrote:
>>
>> I care that if IETD has some plan to push the iscsitarget kernel
>> module (iscsitgt.ko) into the kenrel?
>>
>> I think the iscsitarget kernel module is stable enough to submit into
>> the kernel, if it's inlined in the kernel, everything will go better.
>
> IET kernel module will not be included in the base Linux tree.


>
> Other iSCSI modules have been included in the tree, and that is
> OK. At least for myself I do not see any real advantage to
> inclusion in the tree. If it were, then one would only find it
> in the latest kernel versions which one wouldn't see available
> in production systems for a number of years. Our development group
> is also too small for us to keep on top on the kernel development
> as we would need to do if it were included. We are quite happy
> keeping IET as a third party utility driver and hope to add
> some functionality for distribution maintainers to easily
> build packages for IET inclusion (.spec and .deb files).
>
> Going forward, Arne does a brilliant job of keeping informed
> of the latest kernel API changes which allows us to keep IET
> working on the latest kernels, but we don't shadow the kernel
> developments on a day-by-day basis, so we recommend it best
> to run IET on mature kernel versions.

Have you read the Documentation/ of the kernel?
Didn't you know the benefits of getting the kernel code into the main
kernel tree?

Here is some reasons from Documentation/stable_api_nonsense.txt:

The very good side effects of having your driver in the main kernel tree
are:
  - The quality of the driver will rise as the maintenance costs (to the
    original developer) will decrease.
  - Other developers will add features to your driver.
  - Other people will find and fix bugs in your driver.
  - Other people will find tuning opportunities in your driver.
  - Other people will update the driver for you when external interface
    changes require it.
  - The driver automatically gets shipped in all Linux distributions
    without having to ask the distros to add it.

First, the demand for one iscsi target code inclusion into the main
kernel tree is ongoing,
We need an iscsi target that can run on as much as possible kernels,
not only the mature kernel versions.
In all kinds of our developments, the iscsi target is one basic
functionality we want, we want iscsi can always be buildable at least,
inclusion into the kernel is the best approach.

Second, I hope there will be more people who are interested in
iscsi-target can test and review IET code, and improve IET to better.
Indeed, in sometimes I observed IET kernel module not very stable on
the latest 2.6.26 and 27-rcX kernels, sometimes it's kernel oops
after serveral stop-ietd-unload-ko-load-ko-start-ietd loops, but not
always reproducible, I'm still tracing on it;
the read-iscsi-consuming-100%-CPU is also another problem we observed
in our lab.
All in one word, I hope more people can lay focus on IET to improve its quality.
If we can improved it to production stable earlier, why not?

Last but not least significant, if you think iscsi target development
group is too small to push the code into main kernel tree,
I can help on this, in fact, I have already a latest
keep-up-with-linus git tree with iet kernel code integrated.
If someone is interested on this, we will collate and publish it some later.

>
> -Ross

Thanks.


-- 
Denis Cheng
Linux Application Developer

"One of my most productive days was throwing away 1000 lines of code."
 - Ken Thompson.
