Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbXEYHKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbXEYHKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 03:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbXEYHKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 03:10:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:58599 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbXEYHKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 03:10:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IZK4i0aOYPN0zHNMTlxYBsyg2Em2n2KrRHZ9Lsxg5TRoJBPSaYW27d57K2nsoE0oROyKYATutteVflKfzN7OkrcXuG3FN16WEHhgcMT9Jzk78DPOklJP+eRpI/4WvbEAPjYxxcqC/0/KR5v/nb99TZ7ay4o/wg0Md9gwS4YO9rA=
Message-ID: <a8e1da0705250010t654f5fafs1a054e1978a61726@mail.gmail.com>
Date: Fri, 25 May 2007 07:10:38 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc2-mm1 NTFS & SLUB related fix
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Anton Altaparmakov" <aia21@cantab.net>
In-Reply-To: <20070525000115.e24e027a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0705242201r13a26d92hcb0059f55e15a24a@mail.gmail.com>
	 <Pine.LNX.4.64.0705242202340.1327@schroedinger.engr.sgi.com>
	 <a8e1da0705242222n2414a66bo97d20c82c6a497e4@mail.gmail.com>
	 <20070524224709.0719acfe.akpm@linux-foundation.org>
	 <a8e1da0705242327q48c5d449p2fc028c40b0bfb08@mail.gmail.com>
	 <20070524234353.ad493d42.akpm@linux-foundation.org>
	 <a8e1da0705242348n12aebed7m254677969d718bde@mail.gmail.com>
	 <20070525000115.e24e027a.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm very sorry, andrew, you are right.
I directly modified the source and forgot remove the line ni->name[i] = 0;

Regards
dave
