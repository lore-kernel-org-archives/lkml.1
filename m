Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbYLAIAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbYLAIAL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 03:00:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYLAH7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 02:59:55 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41166 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbYLAH7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 02:59:55 -0500
Date: Mon, 1 Dec 2008 13:29:53 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, jblunck@suse.de, dlezcano@fr.ibm.com,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: [rfc git patch] union directory
Message-ID: <20081201075953.GE3388@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <E1L616K-0005v3-Uc@pomaz-ex.szeredi.hu> <20081128161921.GA3843@in.ibm.com> <E1L6Skx-0007uK-3H@pomaz-ex.szeredi.hu> <20081201043509.GA3388@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081201043509.GA3388@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 10:05:09AM +0530, Bharata B Rao wrote:
> On Sat, Nov 29, 2008 at 05:33:19PM +0100, Miklos Szeredi wrote:
> > On Fri, 28 Nov 2008, Bharata B Rao wrote:
> > 
> > The plan is to get a simple kernel implementation first which caches
> > the directory in 'struct file'.
> 
> FYI, I did this for a version of Union Mount.
> (http://lkml.org/lkml/2007/6/20/21) I was maintaining the readdir cache in
> struct file and the cache was persistant across readdir calls.
> 
> Do you have anything different in mind ?

The version pointed to by me above had the entire cache stored
in the struct file of the topmost directory. I guess your plan
is to cache them per branch and combine them during
readdir()/getdents() ?

Regards,
Bharata.
