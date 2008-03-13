Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbYCMRz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbYCMRz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 13:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbYCMRzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 13:55:22 -0400
Received: from rn-out-0910.google.com ([64.233.170.186]:8385 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbYCMRzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 13:55:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EnRlDWeV8q0qoVzb+z9kGHnQzFSS9h8+5F/TSALsDxMhh6RSfxEfeqvdGgjibmjMgL3qE+Q9BNNVFFB6pfNTm2HQUwb2ueQi3SbH7p6H6i0k8oD2S4Nz2BjN2SPNnnIsf2R9wLpMXCLS56YkHYmCAPHH0mulcZu6SIDJgDlIZl0=
Message-ID: <3d8471ca0803131055w247386e7g9bbea665bf78ca6e@mail.gmail.com>
Date: Thu, 13 Mar 2008 18:55:18 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Badari Pulavarty" <pbadari@us.ibm.com>
Subject: Re: 2.6.25-rc5-mm1 - x86_64 boot problem with git-sched.patch
Cc: "Andrew Morton" <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl,
       mingo@elte.hu, vatsa@linux.vnet.ibm.com,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1205430028.19403.19.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	 <1205345451.23611.6.camel@dyn9047017100.beaverton.ibm.com>
	 <20080312111509.301c9d24.akpm@linux-foundation.org>
	 <1205428180.19403.15.camel@dyn9047017100.beaverton.ibm.com>
	 <1205430028.19403.19.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 6:40 PM, Badari Pulavarty <pbadari@us.ibm.com> wrote:
>  commit 60befbc1c0b6d141c9c26e61ddd303aedd1e7396
>  Author: Guillaume Chazarain <guichaz@yahoo.fr>
>  Date:   Mon Mar 10 08:16:41 2008 +0100
>
>     sched: make sure jiffies is up to date before calling
>  __update_rq_clock()

I didn't know this patch could prevent booting, but anyway it should
have been removed a long time ago:
http://lkml.org/lkml/2008/1/25/408

Thanks.

-- 
Guillaume
