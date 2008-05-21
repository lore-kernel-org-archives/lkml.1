Return-Path: <linux-kernel-owner+w=401wt.eu-S932905AbYEUAlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905AbYEUAlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755748AbYEUAlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:41:15 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:58925 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486AbYEUAlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:41:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P2l3ggH8QEwpAvnYM9ACO5EC3sD0b4ccv6yUvO8egDGeVsqbRr1itOLGGEkFAvR7JaNMUd9hI+kUzrhFbizz5J2D1JRDnceSFlnzexoNRBsSzyiu7+tNGP6Tcqa8AfTd8W5rDpE+eKfNkUou5PmjAs30xGETa8kjg+MKuVXitys=
Message-ID: <8bd0f97a0805201741h13e44c4dkead97118d7d137e8@mail.gmail.com>
Date: Tue, 20 May 2008 20:41:13 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: + pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2.patch added to -mm tree
Cc: "Bryan Wu" <cooloney@kernel.org>, linux-kernel@vger.kernel.org,
       michael.hennerich@analog.com
In-Reply-To: <20080520010223.5e55d074.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805200608.m4K68d0N008092@imap1.linux-foundation.org>
	 <386072610805200051tcbf2d1bpcb981749c16879b6@mail.gmail.com>
	 <20080520010223.5e55d074.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 4:02 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 20 May 2008 15:51:13 +0800 "Bryan Wu" <cooloney@kernel.org> wrote:
>> Need I resend out the a new patch which fold these 3 patches together.
>> it is easier for you to maintain.
>
> Nope,  I keep the patches separate and then fold them prior to sending
> to Linus.
>
> I marked this as for-2.6.26 as it's clearly non-injurious to existing stuff.
>
> This:
>
>> -#if defined(__arm__) || defined(__mips__) || defined(__avr32__)
>> +#if defined(__arm__) || defined(__mips__) || defined(__avr32__) || defined(bfin)
>
> should probably be using CONFIG_foo but that might not work if it's to
> be preprocessed by userspace.  I didn't look.  Plus that'd be
> off-topic.

it should be defined(__bfin__) at least.  perhaps i should add that
check to checkpatch.pl as well ...
-mike
