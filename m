Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbZJBJbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbZJBJbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbZJBJbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:31:14 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:45892 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757374AbZJBJbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:31:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=QFP6W41aGRHRZ15klyWEgvl2FTSKnBDGUmhxGUuSFN5CZKJGONHfd6pTg4H43yhMFG
         0wupjCnAYf/VfoZsEVAMqqtK/+aF6X88KAxOKJfjcrf3Q+D5HqMWvrfOwZ/2SbSpYhJs
         mA27kU8T1bqUsHJN/3j/C12nkob7FyWmLQBF4=
Date: Fri, 2 Oct 2009 11:31:13 +0200
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Subject: [PATCH 2.4] Fix Kernel 2.4 build with bash 4
Message-ID: <20091002113113.20745460@strolchi>
In-Reply-To: <20091002092507.GA26741@1wt.eu>
References: <20091002111711.5de3bf8f@strolchi>
	<20091002092507.GA26741@1wt.eu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.11; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Oct 2009 11:25:07 +0200
Willy Tarreau <w@1wt.eu> wrote:

> This is amazing it has ever worked at all ! None of my scripts which
> use ". $file" without "./" work even in bash 3. Probably this depends
> on some PATH variables and maybe your environment has changed since
> you upgarded to bash 4. 

Well, people started reporting it when distributions (openSUSE FACTORY
and Fedora 11) switched to bash 4. Maybe the shell's defaults are now
just a bit stricter, or the distros abandoned a PATH setting that was
common before, I have no idea.

> Thanks for the fix, I'll merge it.

Thanks! Saves me a local patch ;)

-- 
Stefan Seyfried

"Any ideas, John?"
"Well, surrounding them's out."
