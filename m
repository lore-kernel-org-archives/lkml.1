Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520Ab0A0XQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab0A0XQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081Ab0A0XQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:16:38 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:64453 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab0A0XQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:16:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DaxobGzLiOxacgzIBZGXqEq3sE+jpW2AYyEKsG8YMv443nYOcQ+eBOAW8OIfZm1oQ8
         pFWFjE1Rvbfp4ar4Wa7zsorUiEjKAmdHbKCXgDzm38M8pdZPMrrhZQhBGrcifaCzpsAf
         HOzlBFPoZEJX+ideJAxju7D15r1BaoPxkwFt0=
MIME-Version: 1.0
In-Reply-To: <4B60C1C0.8050402@teksavvy.com>
References: <aacba7e1001260704m27c99a0dy6c3f50c38ce6b430@mail.gmail.com>
	 <20100126160243.018b87e3@lxorguk.ukuu.org.uk>
	 <aacba7e1001260819k24088c81m14b4c702fccddd29@mail.gmail.com>
	 <72dbd3151001261251s606ebf00h86c2ce63293305b6@mail.gmail.com>
	 <aacba7e1001261621v6abb4270i996a28d19c9f7d7@mail.gmail.com>
	 <72dbd3151001261632t7bbe43d0nb7490eae02185c81@mail.gmail.com>
	 <20100127010204.7976c38b@lxorguk.ukuu.org.uk>
	 <aacba7e1001261714n42a68824k62c411cd1e5d7893@mail.gmail.com>
	 <4B60C1C0.8050402@teksavvy.com>
Date: Thu, 28 Jan 2010 04:46:37 +0530
Message-ID: <aacba7e1001271516k3bb82a0fq7e019b28f3b8972f@mail.gmail.com>
Subject: Re: [PATCH] ata: Disable NCQ for Crucial M225 brand SSDs
From: Vishal Rao <vishalrao@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Rees <drees76@gmail.com>,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, trivial@kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/28 Mark Lord <kernel@teksavvy.com>:
> The errors in that log indicate bad media.
> So the question is, can you demonstrate Win7rc NOT having the same
> errors when accessing the SAME (logical) sectors ?

Would that mean I have to blow away my precious ext4 partitions and
have them Win7rc NTFS formatted and run a full check-disk with
bad block checking enabled?

I can do that, but probably over the weekend since I'll have to backup files
and what not.

In the mean time, can I run a linux command (please tell me what it is or
I will search for something to run online) or tool while NCQ is disabled (via
libata.force=noncq) that can do a disk scan with bad block checking?

If that linux command/tool does not show errors, will that be sufficient to
demonstrate that my disk does not have bad blocks without the need to
run Win7rc?
