Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbYKZITc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbYKZITc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750696AbYKZITW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:19:22 -0500
Received: from mail-gx0-f11.google.com ([209.85.217.11]:45640 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYKZITV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:19:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MTKjJ6pVAVW2OYva18TEsY3WiTPAHzjsWB/oTKtov9Rk0/KwxtmkT+Jrwg7LQhHNnl
         zz9NxoLLk6x1b17Kdv6CYxPDPJQ6S6UMhH/xyOGq2GI0q9KkRfcB89Fw/s1jIuV8wfUC
         38w2tQ3QMS+k1k2R99+G2R6NH6DlkolOBRrbI=
Message-ID: <b637ec0b0811260019q38564411qf586282984236e22@mail.gmail.com>
Date: Wed, 26 Nov 2008 09:19:20 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jay Fenlason" <fenlason@redhat.com>
In-Reply-To: <492CA046.9010501@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b637ec0b0811230817x5b445a0m665305d2b6bf6c1f@mail.gmail.com>
	 <492A5557.2010404@s5r6.in-berlin.de> <200811260015.24549.rjw@sisk.pl>
	 <200811260031.20079.rjw@sisk.pl> <492CA046.9010501@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Nov 26, 2008 at 2:03 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Rafael J. Wysocki wrote:
>> Also, on a possibly related note, I've just found a report from a Mac Mini user
>> who told me his machine hanged during resume from hibernation if his external
>> firewire drive was connected to the port.  He worked around the problem by
>> switching to the new firewire stack that worked for him.
>
> The above bisection result is about the new stack = drivers/firewire/.
> The old stack is drivers/ieee1394/ and I prefix all its changes with
> "ieee1394:".
>
> Of course the old stack is supposed to hibernate + restore properly too.
> I personally tested only suspend + resume though, and that's quite long
> ago...

FWIW, I don't own any firewire devices, I only compiled the stack to
see if the port was recognised by the kernel. So nothing has ever be
connected to that port.

I haven't reproduced the problem so far without the drivers compiled
in (and with the debug option you suggested). I'll post some more info
in a few days.

> --
> Stefan Richter
> -=====-==--- =-== ==-=-
> http://arcgraph.de/sr/
>

Regards,
Fabio
