Return-Path: <linux-kernel-owner+w=401wt.eu-S1752982AbXCaLyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbXCaLyS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 07:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbXCaLyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 07:54:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:1576 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbXCaLyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 07:54:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=rT38c+2BhCzsd8w3SrG9ujBVobqD0xv736XE4i4vtvgNox8eAclv8/1kGu2vfpqp232h30UNcsyoVD4uk4B15v9JmwF97iU8uBXadjGbqjrKzt45NVbngNdXCCd//zic72tMIS1MHbq8+9SheM8ICIASSkyMGiXe7d2AWdhRPZU=
Message-ID: <84144f020703310454t5dcbcaf8la43ff6146132a579@mail.gmail.com>
Date: Sat, 31 Mar 2007 14:54:16 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Peter Samuelson" <peter@p12n.org>
Subject: Re: [powerpc] RS/6000 43p-150 no longer boots as of 2.6.18
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070331035052.GA10131@p12n.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070331035052.GA10131@p12n.org>
X-Google-Sender-Auth: 5853d5bf20661568
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 3/31/07, Peter Samuelson <peter@p12n.org> wrote:
> ...and here it hangs.  This happened between 2.6.17-git21 and -git22.
> .config is attached.  I'd be happy to test patches and provide more
> information.

You could try git bisect to find the exact commit that broke your kernel:

http://www.kernel.org/pub/software/scm/git/docs/howto/isolate-bugs-with-bisect.txt
