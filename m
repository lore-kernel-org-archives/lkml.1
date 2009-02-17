Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbZBQSXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbZBQSXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 13:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbZBQSWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 13:22:31 -0500
Received: from host671420017099.direcway.com ([67.142.99.170]:36940 "EHLO
	aexorsyst.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbZBQSWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:22:30 -0500
X-Greylist: delayed 517 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Feb 2009 13:22:28 EST
From: "John Z. Bohach" <jzb2@aexorsyst.com>
To: linux-kernel@vger.kernel.org
Subject: Re: can't modify /etc/exports without blowing away existing clients
Date: Tue, 17 Feb 2009 10:12:06 -0800
User-Agent: KMail/1.9.6
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org
References: <200902161220.20474.jzb2@aexorsyst.com> <20090217171404.GB9489@fieldses.org>
In-Reply-To: <20090217171404.GB9489@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902171012.07012.jzb2@aexorsyst.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No, that shouldn't happen.  As trond says, check whether you have the
> "nfsd" filesystem mounted.

Thanks...got it resolved...squirrly startup script was mounting nfsd fs 
just after it started rpc.statd...

--john
