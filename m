Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbZBIOut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbZBIOut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 09:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbZBIOul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 09:50:41 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:37568 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbZBIOul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 09:50:41 -0500
Subject: Re: [PATCH 5/6] fs/btrfs/volumes.c: remove useless kzalloc
From: Chris Mason <chris.mason@oracle.com>
To: Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0902082245250.25891@ask.diku.dk>
References: <Pine.LNX.4.64.0902082245250.25891@ask.diku.dk>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 09:50:26 -0500
Message-Id: <1234191026.1262.1.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.499042B5.00BE:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-08 at 22:45 +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The call to kzalloc is followed by a kmalloc whose result is stored in the
> same variable.
> 
> The semantic match that finds the problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 

Now that is neat.  Thanks for the patch, I've queued it up here.

-chris


