Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbYIXPoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbYIXPoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 11:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYIXPoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 11:44:06 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:1486 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbYIXPoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 11:44:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EhfcFCO7BqgmBX/pvKQPcMCf6iOlUidJUO8G7auCK+TP/hDq22Rp5GFk6sYD24aJ6m
         HwfLKij64DgwIuGMQ9phOivkMSZ/AFvCN/8HQhGdBiCaqPQyrwuyMBZ+dC9SycQ8RAiT
         cNHusFP+AR5IfmxFEWMQgr672vInJWaETGhEo=
Message-ID: <81b0412b0809240844y42218bedqe0e1eb22c067fcc3@mail.gmail.com>
Date: Wed, 24 Sep 2008 17:44:03 +0200
From: "Alex Riesen" <raa.lkml@gmail.com>
To: "rae l" <crquan@gmail.com>
Subject: Re: please consider remove those tags named master, which is ambigous with master branch
Cc: "Matthias Urlichs" <smurf@smurf.noris.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, git@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <91b13c310809230746o1c2cb694taebc814bea57c8c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <91b13c310808310948r5e9e825as27bcdf381137e179@mail.gmail.com>
	 <91b13c310809230746o1c2cb694taebc814bea57c8c5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/23 rae l <crquan@gmail.com>:
> To Git developers:
>  I found that different git subcommand have inconsitent processing
> about ambiguous refname,
>
> git show will take "master" tag first,
> while git tag -v will take "master" branch first,
>
> So what's your suggestion to fix this? Just simple remove ambiguous refnames?

You can use "refs/tags/master" and "refs/heads/master"...
