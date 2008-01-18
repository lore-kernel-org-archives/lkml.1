Return-Path: <linux-kernel-owner+w=401wt.eu-S1762632AbYARQoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762632AbYARQoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760167AbYARQoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:44:13 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:58324 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759605AbYARQoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:44:12 -0500
In-Reply-To: <4790C756.2040704@redhat.com>
References: <4790C756.2040704@redhat.com>
Mime-Version: 1.0 (Apple Message framework v753)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <63F84201-9D38-4588-B237-A15138E94C5A@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH 0/3] enhanced ESTALE error handling
Date: Fri, 18 Jan 2008 11:41:51 -0500
To: Peter Staubach <staubach@redhat.com>
X-Mailer: Apple Mail (2.753)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter-

On Jan 18, 2008, at 10:35 AM, Peter Staubach wrote:
> Hi.
>
> Here is a patch set which modifies the system to enhance the
> ESTALE error handling for system calls which take pathnames
> as arguments.

The VFS already handles ESTALE.

If a pathname resolution encounters an ESTALE at any point, the  
resolution is restarted exactly once, and an additional flag is  
passed to the file system during each lookup that forces each  
component in the path to be revalidated on the server.  This has no  
possibility of causing an infinite loop.

Is there some part of this logic that is no longer working?
>

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com
