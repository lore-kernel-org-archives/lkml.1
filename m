Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbZKMVgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbZKMVgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 16:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbZKMVgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 16:36:05 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:59900 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbZKMVgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 16:36:04 -0500
Date: Fri, 13 Nov 2009 16:36:02 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: zheng.yan@oracle.com, linux-btrfs@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: BTRFS: unreachable code found
Message-ID: <20091113213602.GF11332@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Jiri Slaby <jirislaby@gmail.com>, zheng.yan@oracle.com,
	linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <4AFD35DB.6050604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFD35DB.6050604@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AFDD145.00FB:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 11:32:59AM +0100, Jiri Slaby wrote:
> Hi,
> 
> Stanse found unreachable code in btrfs_insert_some_items below (don't
> look at the line numbers, they are on preprocessed code). I would fix
> that if I knew how.

It turns out the entire function isn't used anymore.  We can safely
delete it.

-chris
