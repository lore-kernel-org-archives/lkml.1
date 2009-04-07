Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbZDGM6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbZDGM6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbZDGM6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:58:37 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:40573 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbZDGM6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:58:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=thuhWArdIPMfKMrL5d6yJRY9bp2SsBBFIcavqoMMqy4d2SewdvRTYy72usuNLWIKUk
         fa/ZuN9Ogwsh5iSyHRB5RRBc5FNqrpZAOlXf44+S9uuaYUf6ki89SbhuEvfTY/62QGxU
         2O/nNt1hPo9DOf+FIiNBFW4/e4L/G5ZBTW8ks=
MIME-Version: 1.0
In-Reply-To: <20090407003524.41c9b666.akpm@linux-foundation.org>
References: <52041.128.227.162.217.1238684768.squirrel@webmail.cise.ufl.edu>
	 <20090407003524.41c9b666.akpm@linux-foundation.org>
Date: Tue, 7 Apr 2009 08:58:34 -0400
X-Google-Sender-Auth: d5a6744bd9e3f82a
Message-ID: <c5764b870904070558u51ec2e82ob26c8aabb2976f4e@mail.gmail.com>
Subject: Re: I/O throughput problem in newer kernels
From: Alin Dobra <adobra@cise.ufl.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew (and other people interestead),

I forgot to mention in the post that I used O_DIRECT for all tests
(including dd tests). The CPU utilization is negligible; keep in mind
that the machine has 32 cores so cpu should not be  problem, or memory
bandwidth for that matter. The think that puzzles me the most is the
fact that the throughput does not level up, it goes down dramatically
(a factor of 3 for 54 hard drives versus 20 hard drives).

Alin

--
Alin Dobra
Assistant Professor
Computer Information Science & Engineering Department
University of Florida
