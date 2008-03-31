Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbYCaKic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbYCaKic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 06:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYCaKiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 06:38:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbYCaKiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 06:38:21 -0400
Subject: Re: [PATCH 1/5] fs/gfs2: test for IS_ERR rather than 0
From: Steven Whitehouse <swhiteho@redhat.com>
To: Julia Lawall <julia@diku.dk>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0803241908210.32740@ask.diku.dk>
References: <Pine.LNX.4.64.0803241908210.32740@ask.diku.dk>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 31 Mar 2008 11:35:43 +0100
Message-Id: <1206959743.3635.123.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2008-03-24 at 19:08 +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The function gfs2_inode_lookup always returns either a valid pointer or a
> value made with ERR_PTR, so its result should be tested with IS_ERR, not
> with a test for 0.
> 
Sorry for the delay - I've just got back from holiday. Its now in the
GFS2 -nmw git tree. Also I updated the tree to the latest Linus git tree
at the same time. Thanks,

Steve.


