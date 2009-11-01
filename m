Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672AbZKAWIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbZKAWIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 17:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbZKAWIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 17:08:21 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:63461 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbZKAWIU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 17:08:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=buO0XmK3XB/psLkWxzZMdzG05rluM5MS1BGrXyc79LI7OzWqpT4Y5D1SDFX01JmgKu
         u+mTADQ/aeEDDGpKj7OE1VohOA6r9P3IzR7zZAixPqM8Lb1ZAeVTtIVGCHAS0k/HZU6u
         cWYsHibTWPReKfYazbqSXNFkO6865xKGqb5WI=
MIME-Version: 1.0
In-Reply-To: <yw1xhbte0wx0.fsf@unicorn.mansr.com>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
	 <1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com>
	 <alpine.OSX.1.10.0911011540400.53392@caridad.local>
	 <yw1xhbte0wx0.fsf@unicorn.mansr.com>
Date: Sun, 1 Nov 2009 17:08:24 -0500
Message-ID: <73a01bf20911011408v5b6d335fj46c893a8e7d26ab4@mail.gmail.com>
Subject: Re: FatELF patches...
From: Rayson Ho <raysonlogin@gmail.com>
To: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       "Ryan C. Gordon" <icculus@icculus.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/1 Måns Rullgård <mans@mansr.com>:
> I've read the list, and I can't find anything I agree with.  Honestly.

+1.

Adding code that might bring lawsuits to Linux developers,
distributors, users is a BIG disadvantage.

And beside the legal issues, this first point is already not right:

"Given enough disc space, there's no reason you couldn't have one DVD
.iso that installs an x86-64, x86, PowerPC, SPARC, and MIPS system"

The boot loader is different on different systems, and in fact
different with different firmware. A single DVD that can boot on
different hardware platforms might not be an easy thing to do.

Also, why not build the logic for picking which binary to install into
the installer?? This way, the users don't need to have half of the
disk space wasted due to this FatELF thing.

IMO, the biggest problem users get is not with which hardware binary
to download, but the incompatibly of different Linux kernels and glibc
(the API/ABI).

Rayson
