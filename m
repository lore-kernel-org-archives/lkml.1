Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbZHKRQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbZHKRQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 13:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbZHKRQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 13:16:28 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:44921 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754662AbZHKRQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 13:16:27 -0400
Subject: Re: NULL pointer dereference in __put_nfs_open_context()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-nfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1249995530.12218.3.camel@heimdal.trondhjem.org>
References: <1249990719.27150.52.camel@pc1117.cambridge.arm.com>
	 <1249995530.12218.3.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 11 Aug 2009 18:16:24 +0100
Message-Id: <1250010984.30628.15.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Aug 2009 17:16:25.0663 (UTC) FILETIME=[74E6E4F0:01CA1AA7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-11 at 08:58 -0400, Trond Myklebust wrote:
> How about the following instead? This patch gets rid of those
> nfs_open_context references altogether...

It fixes the kernel oops.

Thanks.

-- 
Catalin

