Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbZG0Q2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbZG0Q2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbZG0Q2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:28:51 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:57671 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbZG0Q2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:28:50 -0400
Date: Mon, 27 Jul 2009 12:28:39 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Julia Lawall <julia@diku.dk>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 9/12] fs/btrfs: Correct redundant test
Message-ID: <20090727162839.GB895@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Julia Lawall <julia@diku.dk>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0907271814490.2682@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907271814490.2682@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.4A6DD5B9.01D7:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 06:15:05PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> dir has already been tested.  It seems that this test should be on the
> recently returned value inode.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://www.emn.fr/x-info/coccinelle/)

Thank you, this is queued up in my tree along with the
other btrfs patches you've sent.

-chris
