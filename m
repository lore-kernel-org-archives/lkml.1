Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbYJNCQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbYJNCQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 22:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbYJNCQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 22:16:21 -0400
Received: from M4.sparta.com ([157.185.61.2]:56919 "EHLO M4.sparta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbYJNCQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 22:16:19 -0400
Message-ID: <48F400DD.50905@sparta.com>
Date: Mon, 13 Oct 2008 22:15:57 -0400
From: "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: "David P. Quigley" <dpquigl@tycho.nsa.gov>, labeled-nfs@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
       selinux@tycho.nsa.gov
Subject: Re: [Labeled-nfs] [RFC v3] Security Label Support for NFSv4
References: <1222707986-26606-1-git-send-email-dpquigl@tycho.nsa.gov> <alpine.LRH.1.10.0810141014580.26030@tundra.namei.org>
In-Reply-To: <alpine.LRH.1.10.0810141014580.26030@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Oct 2008 02:15:59.0998 (UTC) FILETIME=[CCC1E1E0:01C92DA2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> On Mon, 29 Sep 2008, David P. Quigley wrote:
> 
>> 	* New security flavor (auth_seclabel) to transport process label to
>> 	  server. This is a derivative of auth_unix so it does not support
>> 	  kerberos which has its own issues that need to be dealt with.
> 
> This is a problem, as discussed last year:
> 
> http://linux-nfs.org/pipermail/labeled-nfs/2007-November/000110.html
> 
> We can't require the use of a new auth flavor which is incompatible with 
> auth_gss.

auth_seclabel demonstrates the flavor independent changes required for 
any RPC layer process label transport.  A GSS solution is currently 
under discussion.
