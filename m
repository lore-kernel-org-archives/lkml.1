Return-Path: <linux-kernel-owner+w=401wt.eu-S1764183AbYCDVUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764183AbYCDVUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760088AbYCDVTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:19:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:19943 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506AbYCDVTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:19:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=JZ5Lq2LmUB3ORgKwJBB7aCdeajcj/UH7zJXDOYYg8PIPeW/qQMZarmxVjQ43dlna7O2TATOMziq3y4JQwoHndAwBHKxyyL4E5timR6C6Ms44msCnBr9WRdLNaFgFJcJf6J0xBCF6F9KuwMjuEnS6Wob5Di+OA/8WFC1stynPF2I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 09/14] ide: replace remaining __FUNCTION__ occurrences
Date: Tue, 4 Mar 2008 22:25:31 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide <linux-ide@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com> <1204600190.22933.89.camel@brick>
In-Reply-To: <1204600190.22933.89.camel@brick>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803042225.31306.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2008, Harvey Harrison wrote:
> __FUNCTION__ is gcc-specific, use __func__
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

applied

[ I fixed checkpatch.pl errors in ide-lib.c and ppc/mpc8xx.c while at it ]
