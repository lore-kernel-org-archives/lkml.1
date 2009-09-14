Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbZINMeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbZINMeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 08:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbZINMeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 08:34:36 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:53003 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480AbZINMed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 08:34:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=p/almipSvu99h7Joe0WdDr9ifGeHkVvIFOhNrPNiTexpxKnZXvrTgF9Np1Or6YIkWA
         gTCKTnkbeRvCKNVw+vacCp10nB38ZPxKApriiSPlHFFvGxWiMWIF/mXFPw0pQt0ikwaS
         sYnOt6UgGntCU1cdiuA4Zy7Jzo/4tNcQBMNnU=
MIME-Version: 1.0
In-Reply-To: <200909141335.44313.goretux@gmail.com>
References: <200909141335.44313.goretux@gmail.com>
Date: Mon, 14 Sep 2009 08:34:37 -0400
Message-ID: <817ecb6f0909140534m62392cc2v8e5aacc35034661c@mail.gmail.com>
Subject: Re: Eliminating kernel mixed page (code + data)
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: Eric Lacombe <goretux@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Greg KH <gregkh@suse.de>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Eric Lacombe <eric.lacombe@security-labs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> First, is there a kernel option to enforce kernel code and kernel data
> separation among pages ?

I do not think so.

> Otherwise, is it sufficient to enforce page alignment for the start address of
> all data segment, to achieve this goal ?
> (on top of using CONFIG_RELOCATABLE)

AFAIK, this would be required but not sufficient. I am currently
working on a set of patches that:
1. eliminate mixed pages in kernel space
2. keep data as non-executable and code as read-only

As a starting point, you can search for my name in the mailing list to
see the patches and the discussion around them.
