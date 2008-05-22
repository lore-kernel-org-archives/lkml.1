Return-Path: <linux-kernel-owner+w=401wt.eu-S935813AbYEVAJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935813AbYEVAJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 20:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759588AbYEVAJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 20:09:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:64291 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736AbYEVAJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 20:09:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pu2OyLrpS9gn8sj1Dv1n126u5yLkngcG8S0LcT/0S56u8awtIjhEX+Qaq/3druuzUW31P43nDTm2caj4L4jy6zjkiztUU193RsKr5OFV6IJNN83g4Cm6PylWaeGCzLV2e8rno261bQmgvzLJE9B5RRIBarPHYENx5kjzBR9B6wY=
Message-ID: <82fa9e310805211709i3993cac2n58152cf11a3ef8a4@mail.gmail.com>
Date: Wed, 21 May 2008 17:09:01 -0700
From: mark <markkicks@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: fork: Resource temporarily unavailable / cant start new threads
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080521163503.000afd61.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82fa9e310805201126q45e869bdub74a947068fe612a@mail.gmail.com>
	 <20080521132845.72db5748.randy.dunlap@oracle.com>
	 <82fa9e310805211339o3090e0d0le8503051d3e0aa38@mail.gmail.com>
	 <48348AFA.1070900@oracle.com>
	 <82fa9e310805211408o65b49923jd9bf4a6c89b97c30@mail.gmail.com>
	 <20080521143248.baee1391.randy.dunlap@oracle.com>
	 <82fa9e310805211551oea0dfd9mdb7dfaed2b2d98fc@mail.gmail.com>
	 <20080521163503.000afd61.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 4:35 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> > I can send you some debug patches that will print out the specific
>> > problem area.  Do you want to do that?  Can you rebuild and install
>> > a new kernel?
>> Is it possible to get this debug messages by turning on some flags?
>> If not yes, pl. send debug patches. its a live box and  I will try to do it!
>>
>> This is my system / kernel info:
>> uname -a
>> Linux XXX 2.6.25.3-18.fc9.x86_64 #1 SMP Tue May 13 04:54:47 EDT 2008
>> x86_64 x86_64 x86_64 GNU/Linux
>
> I made a small patch to a vanilla kernel.org 2.6.25.3 kernel tree.
> Hopefully it applies cleanly to that fc9 kernel source, but check/verify
> that first before going any further.

Thanks a lot for the patch,
This is kind of weird..  but there is no file  kernel/fork.c

[mark@localhost 2.6.25.3-18.fc9.i686]$ find . -iname '*fork*' -print
[mark@localhost 2.6.25.3-18.fc9.i686]$ rpm -ql
[mark@localhost 2.6.25.3-18.fc9.i686]$ rpm -ql kernel-devel | grep fork
[mark@localhost 2.6.25.3-18.fc9.i686]$ pwd
/usr/src/kernels/2.6.25.3-18.fc9.i686
