Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYAZMcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYAZMcq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 07:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYAZMcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 07:32:36 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:10479 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbYAZMce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 07:32:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=RIku51eQYM6Il6N9iMRYepSZnXHKA53B79QtjxPcLOoWzfu6vNjpzPJQtvm4yLyQabsugRVl3hnKeqtB0aJKZxrvvPsafYhsPPDkVwIGIwcuRoooSkFBBRDpeRSYquNi5OcPvH7rglDBJBXABRUnaS07f9mjSNyJUQVg+ML6Vyg=
Message-ID: <2f11576a0801260432y4405d817p6ef4005d06189654@mail.gmail.com>
Date: Sat, 26 Jan 2008 21:32:32 +0900
From: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>
To: "Theodore Tso" <tytso@mit.edu>, "Adrian Bunk" <bunk@kernel.org>,
       "Bodo Eggert" <7eggert@gmx.de>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Andreas Dilger" <adilger@sun.com>, Valdis.Kletnieks@vt.edu,
       "David Chinner" <dgc@sgi.com>, "Valerie Henson" <val@vahconsulting.com>,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Andreas Dilger" <adilger@clusterfs.com>,
       "Ric Wheeler" <ric@emc.com>
Subject: Re: [RFC] Parallelize IO for e2fsck
In-Reply-To: <20080124234037.GJ15858@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9Mo9w-7Ws-25@gated-at.bofh.it> <9Mo9w-7Ws-23@gated-at.bofh.it>
	 <9OdWm-7uN-25@gated-at.bofh.it> <9Oi9A-5EJ-3@gated-at.bofh.it>
	 <9OiMg-6IC-1@gated-at.bofh.it> <9OlqL-2xG-3@gated-at.bofh.it>
	 <9Orda-3ub-45@gated-at.bofh.it>
	 <E1JI5vz-0001GG-Vs@be1.7eggert.dyndns.org>
	 <20080124230809.GA29120@does.not.exist>
	 <20080124234037.GJ15858@mit.edu>
X-Google-Sender-Auth: d5adcb8f240d854a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > And from a performance point of view letting applications voluntarily
> > free some memory is better even than starting to swap.
>
> Absolutely.

the mem_notify patch can realize "just before starting swapping" notification :)

to be honest, I don't know fs guys requirement.
if lacking feature of fs guys needed, I implement it with presure if
you tell me it.
