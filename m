Return-Path: <linux-kernel-owner+w=401wt.eu-S1752400AbZEQGHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbZEQGHQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 02:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZEQGG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 02:06:57 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:14466 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbZEQGG4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 02:06:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=n4XuZ6qIBumxj0mUW46TINK6S1y5cEugDzDLnpvlO+vt0LKPkkZOBr4t6i5ZnmN1ZT
         RYfGJBQhgnJCnL/zoI3jxNq2QELyVbAwAsuHvhoKDmu6TucD3MwpTTbO3/TLh8+eRwoC
         V4d3Dcnzuf3i1HS4bu4Zcl6fmteT3m8IzfT6U=
MIME-Version: 1.0
In-Reply-To: <385Pu-agh7M.A.geC.vZzDKB@chimera>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
	 <385Pu-agh7M.A.geC.vZzDKB@chimera>
Date: Sun, 17 May 2009 14:06:56 +0800
Message-ID: <b6a2187b0905162306u17c07753w8af53b6ed807cf1d@mail.gmail.com>
Subject: Re: [Bug #13118] iptables very slow after commit 784544739a25c30637397ace5489eeb6e15d7d49
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Patrick McHardy <kaber@trash.net>,
       Stephen Hemminger <shemminger@vyatta.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 17, 2009 at 3:20 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13118
> Subject         : iptables very slow after commit 784544739a25c30637397ace5489eeb6e15d7d49
> Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> Date            : 2009-04-10 16:05 (37 days old)
> References      : http://lkml.org/lkml/2009/4/10/111
>                  http://lkml.org/lkml/2009/4/25/83
> Handled-By      : Eric Dumazet <dada1@cosmosbay.com>

Fixed as of Apr 28.

commit 942e4a2bd680c606af0211e64eb216be2e19bf61
Author: Stephen Hemminger <shemminger@vyatta.com>
Date:   Tue Apr 28 22:36:33 2009 -0700

    netfilter: revised locking for x_tables


Thanks,
Jeff.
