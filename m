Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbZECCMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbZECCMi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 22:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbZECCM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 22:12:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43216 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbZECCM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 22:12:29 -0400
Date: Sat, 2 May 2009 22:08:29 -0400
From: Rik van Riel <riel@surriel.com>
To: Izik Eidus <ieidus@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, alan@lxorguk.ukuu.org.uk,
       device@lanana.org, linux-mm@kvack.org, hugh@veritas.com,
       nickpiggin@yahoo.com.au, Izik Eidus <ieidus@redhat.com>
Subject: Re: [PATCH 1/6] ksm: limiting the num of mem regions user can
 register per fd.
Message-ID: <20090502220829.392b7ff9@riellaptop.surriel.com>
In-Reply-To: <1241302572-4366-2-git-send-email-ieidus@redhat.com>
References: <1241302572-4366-1-git-send-email-ieidus@redhat.com>
	<1241302572-4366-2-git-send-email-ieidus@redhat.com>
Organization: surriel
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  3 May 2009 01:16:07 +0300
Izik Eidus <ieidus@redhat.com> wrote:

> Right now user can open /dev/ksm fd and register unlimited number of
> regions, such behavior may allocate unlimited amount of kernel memory
> and get the whole host into out of memory situation.

How many times can a process open /dev/ksm?

If a process can open /dev/ksm a thousand times and then
register 1000 regions through each file descriptor, this
patch does not help all that much...

-- 
All rights reversed.
