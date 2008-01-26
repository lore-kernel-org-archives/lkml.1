Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbYAZL5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbYAZL5y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 06:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756284AbYAZL42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 06:56:28 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:40102 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911AbYAZL4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 06:56:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qS0y/NgdO4x/szFIp14yCzexwCcV8D2kXAgvHQU9GjhCqHeDCeQWxSINAmIv/bEpW883wNRXO80Tnu/pnAyfCwIiwA1+NgUjzHAT+5raEnl8C0s38HwbYjQW1VIkCjU3yBpVnfly5PJeuKLikHm4PoQM4WdFlIqGZzGa9c/3BnA=
Message-ID: <2f11576a0801260356tfbf3078w5ff98e8909e07b6c@mail.gmail.com>
Date: Sat, 26 Jan 2008 20:56:24 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@gmail.com>
To: "Zan Lynx" <zlynx@acm.org>, "Andreas Dilger" <adilger@sun.com>
Subject: Re: [RFC] Parallelize IO for e2fsck
Cc: "Theodore Tso" <tytso@mit.edu>, "Adrian Bunk" <bunk@kernel.org>,
       "Bodo Eggert" <7eggert@gmx.de>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       Valdis.Kletnieks@vt.edu, "David Chinner" <dgc@sgi.com>,
       "Valerie Henson" <val@vahconsulting.com>, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Ric Wheeler" <ric@emc.com>
In-Reply-To: <1201308912.7784.6.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9Mo9w-7Ws-23@gated-at.bofh.it> <9OiMg-6IC-1@gated-at.bofh.it>
	 <9OlqL-2xG-3@gated-at.bofh.it> <9Orda-3ub-45@gated-at.bofh.it>
	 <E1JI5vz-0001GG-Vs@be1.7eggert.dyndns.org>
	 <20080124230809.GA29120@does.not.exist>
	 <20080124234037.GJ15858@mit.edu> <1201220742.7557.10.camel@localhost>
	 <20080125110942.GX18433@webber.adilger.int>
	 <1201308912.7784.6.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The commentary on the mem_notify threads claimed that the signal is
> easily provided by setting up the file handle for SIGIO.

BTW:
Of cource, you can receive any signal instead SIGIO by use fcntl(F_SETSIG)  :-)
