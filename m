Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbYKZTqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbYKZTqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:46:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYKZTpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:45:53 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:28196 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbYKZTpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:45:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=R74ycDcdYEoxtVswVV9+X1rt65QZiN5jrjIGbQtmcyZzDLnyWKx1mVSpDGLV6vpdst
         wreXAyU6M7fEQq0oHbAkiBMDOwcTAs7IM9o6YRm2QEn6fhca63hvpSnbGhrcPumAfoAK
         R5L+Ac6H73doAFei7V4oM690nBNnrOlkcRBPk=
Message-ID: <b637ec0b0811261145q3c7af010l1db0480d13b41715@mail.gmail.com>
Date: Wed, 26 Nov 2008 20:45:50 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jay Fenlason" <fenlason@redhat.com>
In-Reply-To: <492D40F7.2040605@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b637ec0b0811230817x5b445a0m665305d2b6bf6c1f@mail.gmail.com>
	 <492A5557.2010404@s5r6.in-berlin.de> <200811260015.24549.rjw@sisk.pl>
	 <200811260031.20079.rjw@sisk.pl> <492CA046.9010501@s5r6.in-berlin.de>
	 <b637ec0b0811260019q38564411qf586282984236e22@mail.gmail.com>
	 <492D40F7.2040605@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I reproduced the bug with 2.6.27.7 without firewire. So the
firewire stack is innocent after all.
FWIW, it happened after the resume, as soon as I plugged the AC
adapter. The system became unresponsive for at least two minutes and
then "resurrected" as nothing happened. Nothing in the logs and the
dmesg is clean.

I ran out of ideas. I'm trying 2.6.27.4, the kernel then never showed
the problem.

I will also launch a full SMART test on my hd, in case it is the guilty.

Regards,
Fabio

On Wed, Nov 26, 2008 at 1:28 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Fabio Comolli wrote:
>> I haven't reproduced the problem so far without the drivers compiled
>> in (and with the debug option you suggested). I'll post some more info
>> in a few days.
>
> Sounds like I urgently need to set up hibernation on a test PC here.
> Thanks,
> --
> Stefan Richter
> -=====-==--- =-== ==-=-
> http://arcgraph.de/sr/
>
