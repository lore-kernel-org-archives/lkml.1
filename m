Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbYJUVW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbYJUVW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbYJUVWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:22:01 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:52175 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbYJUVWA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:22:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iOsC2tLKlB1IHaZVDp9USIqE4QuTYsgpceVf7/+7MFaNeWBBGpbm4o8m9OX3XwrdCt
         E+2pbsjChRJW/dX6OlS0V8cEClaOSdq3AjzrrljE37noyWcJbnAMVnnk5faxDjmzusZS
         Emt+MrDxfmAZUnH6ZjLjHq/Q1bKfIopCSQ8lA=
Message-ID: <2bfaaf400810211421i100d10fexbea8f74d86d813de@mail.gmail.com>
Date: Tue, 21 Oct 2008 18:21:58 -0300
From: "Alexandre Lymberopoulos" <lymber@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>,
       "=?ISO-8859-1?Q?Rog=E9rio_Brito?=" <rbrito@ime.usp.br>,
       "Alexandre Lymberopoulos" <lymber@gmail.com>, 502583@bugs.debian.org,
       502583-submitter@bugs.debian.org, linux-kernel@vger.kernel.org
Subject: Re: Bug#502583: scary messages in dmesg
In-Reply-To: <20081021123348.GB15685@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <2bfaaf400810172145g4aba4827l87a19e67b9742815@mail.gmail.com>
	 <20081018060400.GB916@ime.usp.br>
	 <2bfaaf400810201654u21c9d950o72b2afa9496ba3da@mail.gmail.com>
	 <20081021101510.GA16244@ime.usp.br> <20081021123348.GB15685@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 9:33 AM, Theodore Tso <tytso@mit.edu> wrote:

> A patch to suppress the WARN information will be in 2.6.28 when the
> user does something stupid (i.e., yank out a USB stick without
> unmounting the filesystem first).  This was done mainly to suppress
> the "scary message" in dmesg, which on distributions that support
> uploading such messages to http://www.kerneloops.org for analysis, was
> cluttering the reports.

I don't think removing these messages is a good idea. It's good even
for non-developer users to have information about what is happening on
their systems. At least to know that they (me in that case) did
something stupid.

> However, the patch does not make it any *safer* to uncerimoniously
> yank out a USB stick without unmounting it first.  This can still lead
> to data loss, unless you're *sure* that no process is writing to the
> stick and you issued the sync command, and you know enough time has
> passed so all of the data has been written to the USB stick.

Another reason to keep these messages. To hide information without
provinding a solution (I can see none here, i´'s impossible to prevent
anyone from doing stupid things) is not a good idea, sounds like the
philosophy of other operating systems...

> If you see "lost page write due to I/O error", then you will have lost
> data due to premature removal of the USB stick, and fundamentally
> *that* bug exists between the keyboard and the chair.

;-)

> Regards,
>
>                                                - Ted

Sincerley, Alexandre
-- 
===============================================================================
Alexandre Lymberopoulos - lymber@gmail.com
===============================================================================
