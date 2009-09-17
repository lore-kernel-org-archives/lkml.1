Return-Path: <linux-kernel-owner+w=401wt.eu-S1760492AbZIQBee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760492AbZIQBee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 21:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760121AbZIQBec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 21:34:32 -0400
Received: from mail-yx0-f182.google.com ([209.85.210.182]:51306 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758357AbZIQBeb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 21:34:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=EP66C3VBeOTmu5agorR5ql6ZVisiGlARXs2EszWnktKfqReG3nKcH35Q98HyPlSerd
         9xpJqXPEkNkBX7nY4UvBAO1/I2pvNXrl4Kd5We0yKJmTu0TMHN/HFo9fX2MUn5Y6prjS
         h9diwbpPI3Ct/KbgQStouufVq3HhOmMO2ut+Y=
MIME-Version: 1.0
In-Reply-To: <20090917112604.acbae122.sfr@canb.auug.org.au>
References: <20090917112604.acbae122.sfr@canb.auug.org.au>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 16 Sep 2009 21:34:15 -0400
Message-ID: <8bd0f97a0909161834j328abe5aq96b7cb69893d1094@mail.gmail.com>
Subject: Re: linux-next: manual merge of the blackfin tree with Linus' tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 21:26, Stephen Rothwell wrote:
> Today's linux-next merge of the blackfin tree got a conflict in
> arch/blackfin/mm/sram-alloc.c between commit
> b9bf3121af348d9255f1c917830fe8c2df52efcb ("percpu: use
> DEFINE_PER_CPU_SHARED_ALIGNED()") from Linus' tree and commit
> 40bf94d6d1158fb6d6d67a666e6b16ab6ac3986e ("Blackfin: push SRAM locks down
> into related ifdefs") from the blackfin tree.
>
> The latter moved the code that the former modified.  I fixed it up (see
> below) and can carry the fix for a while.

ive pulled down the latest mainline and rebased my branch onto it.
thanks for the heads up.
-mike
