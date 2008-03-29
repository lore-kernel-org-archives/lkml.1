Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbYC2Bdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbYC2Bdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 21:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbYC2Bdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 21:33:32 -0400
Received: from n5b.bullet.mail.ac4.yahoo.com ([76.13.13.75]:25616 "HELO
	n5b.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755740AbYC2Bda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 21:33:30 -0400
X-Yahoo-Newman-Id: 318728.62830.bm@omp202.mail.re3.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xLuAW1HfaLVNnRvrhYLm2kr07e1KW51kWkvIVmVm4CjGuQrpAOaIG1L1DEet4ebIzK6If28bTMGjZgOpDv0PFVIoTUtYaNs0fv0lKuwBVl96LsVzTSj3f7VyzVhHqxGBy9jZmjGiHg5aI0OQfl9dqAjQV6v2Nq7iS/qZXrqCI/M=  ;
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Steve French" <smfrench@gmail.com>
Subject: Re: Can kmem_cache_free block?
Date: Sat, 29 Mar 2008 12:15:36 +1100
User-Agent: KMail/1.9.5
Cc: lkml <linux-kernel@vger.kernel.org>
References: <524f69650803281223v5e54e1c1na8a46da2e0a3df4c@mail.gmail.com>
In-Reply-To: <524f69650803281223v5e54e1c1na8a46da2e0a3df4c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803291215.37108.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 March 2008 06:23, Steve French wrote:
> Is kmem_cache_free safe to call while holding a spinlock (can
> kmem_cache_free ever block or recurse into a file system)?
>
> I see it trying to grab just another spinlock which is probably fine
> (but was worried whether any of the worker functions called a sem) ...
> my assumption is that it would be safe, but the man page doesn't
> mention when it can be used safely.

Yes you can call it from any context.

