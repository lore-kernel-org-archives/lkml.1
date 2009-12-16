Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbZLPAsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbZLPAsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 19:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZLPAse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 19:48:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55191 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbZLPAse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 19:48:34 -0500
Date: Wed, 16 Dec 2009 01:48:26 +0100
From: Andi Kleen <andi@firstfloor.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       linux-kernel@vger.kernel.org, Trond.Myklebust@netapp.com
Subject: Re: NFS lockdep lock misordering mmap_sem<->i_mutex_key with
	2.6.32-git1
Message-ID: <20091216004826.GA3622@basil.fritz.box>
References: <20091215222134.GA27892@ZenIV.linux.org.uk> <20091215233841.GE22392@basil.fritz.box> <20091216085051.CDE2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216085051.CDE2.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> afaik, no revalidate mean "I don't mind the file was already removed
> at server, I only care client handle".
> 
> What's happen if we mmap removed file? 

I thought NFS only provided consistency around open/close/msync, not around
mmap? I've never been aware of mmap being a synchronization point.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
