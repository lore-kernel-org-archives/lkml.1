Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbYCMT0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbYCMT0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 15:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYCMT0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 15:26:12 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:35376 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751672AbYCMT0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 15:26:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4z2kUTN3sEMVCckFK5empQuY5uLZsJdxR4SkBfCqlmnqrFZkXFUuVGSFVqP+MtBS7aZaGyhlAOk3F+MgoO7HYdPdTXq2NHXuI2dGrvviB2N8cm7JodaA8NdrjHtxQBStngXX59xk+1dk9Io8RsBWkNoypURaDrCiAp40NLy4G+U=  ;
X-YMail-OSG: YRb23fQVM1kgMOGIl_3YtkObdajnrtXeHdGGal.Go4ZP0q_ls9.sNUeaNKamLoUPsvy4bIGe6Q--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH 01/10] mtd: maps/physmap: fix oops in suspend/resume/shutdown ops
Date: Thu, 13 Mar 2008 11:26:07 -0800
User-Agent: KMail/1.9.6
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       Anton Vorontsov <cbouatmailru@gmail.com>
References: <> <1205419185-26395-1-git-send-email-hskinnemoen@atmel.com> <1205419185-26395-2-git-send-email-hskinnemoen@atmel.com>
In-Reply-To: <1205419185-26395-2-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803131226.08329.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008, Haavard Skinnemoen wrote:
> ...
> [ 42.351266] Flash device refused suspend due to active operation (state 0)
> [ 42.358195] Unable to handle kernel NULL pointer dereference at virtual address 00000078
> [ 42.360060] pgd = c7d9c000
> [ 42.362769] [00000078] *pgd=a7d8d031, *pte=00000000, *ppte=00000000
> [ 42.372902] Internal error: Oops: 17 [#1]
> [ 42.376911] Modules linked in:
> [ 42.379980] CPU: 0    Not tainted  (2.6.25-rc2-10642-ge8f2594-dirty #73)
> [ 42.380000] PC is at physmap_flash_shutdown+0x28/0x54
> ...

I sure hope this regression fix gets merged before 2.6.25-final ...
I've seen it too, came up with a different (quick'n'dirty) fix.

- Dave
