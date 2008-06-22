Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbYFVTWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbYFVTWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYFVTWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:22:04 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:38322 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbYFVTWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:22:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=V3rP3HKVq5L86awq9wCSxmObnjyyBOMqrYI4MxAhZX3Ya4hetreQoMVHhnB/Go5LyS
         U4AwZpHbE8EQhmLCScmVaginc7ruPi7V4d2JATAz8JIHhcN4EpAI9XJXsDjOnY7d887C
         CVwsy8BjEQjAJfMPw0oJURskeLWaroEKqzkjI=
Message-ID: <84144f020806221222s7498593ap7cad427405fb6776@mail.gmail.com>
Date: Sun, 22 Jun 2008 22:22:00 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH 2/3] Better interface for hooking early initcalls.
Cc: tzanussi@gmail.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, compudj@krystal.dyndns.org,
       vegard.nossum@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080621171051.5ed3b522@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080621171051.5ed3b522@linux360.ro>
X-Google-Sender-Auth: e8a2abec810ad275
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduard,

On Sat, Jun 21, 2008 at 5:10 PM, Eduard - Gabriel Munteanu
<eduard.munteanu@linux360.ro> wrote:
> Added early initcall (pre-SMP) support, using an identical interface to
> that of regular initcalls. Functions called from do_pre_smp_initcalls()
> could be converted to use this cleaner interface.

As there aren't that many functions called from do_pre_smp_initcalls()
, I'd suggest you just go ahead and convert them to get this patch
merged to mainline.
