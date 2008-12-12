Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbYLLWyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbYLLWyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 17:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbYLLWyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 17:54:25 -0500
Received: from M4.sparta.com ([157.185.61.2]:33705 "EHLO M4.sparta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbYLLWyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 17:54:24 -0500
Message-ID: <4942DB18.6060002@sparta.com>
Date: Fri, 12 Dec 2008 16:43:52 -0500
From: "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: "David P. Quigley" <dpquigl@tycho.nsa.gov>, labeled-nfs@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
       selinux@tycho.nsa.gov
Subject: Re: [Labeled-nfs] [PATCH 09/14] NFS: Add security_label text mount
 option and handling code to NFS
References: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>	<1227733394-1114-10-git-send-email-dpquigl@tycho.nsa.gov> <alpine.LRH.1.10.0812051546560.12208@tundra.namei.org>
In-Reply-To: <alpine.LRH.1.10.0812051546560.12208@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2008 21:45:11.0630 (UTC) FILETIME=[E8C2AEE0:01C95CA2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> On Wed, 26 Nov 2008, David P. Quigley wrote:
> 
>> +	{ Opt_security_label, "security_label" },
>> +	{ Opt_nosecurity_label, "nosecurity_label" },
> 
> "seclabel" might be easier for admins to type.

Maybe, though the option is on by default on the client (that is, if the 
server supports security_labels then the client will use it, unless 
instructed not to.)

To explain the choice in a longer name, I've got an RPC auth flavor for 
demonstrating client process label transport called 'auth_seclabel' that 
  is turned on in /etc/exports via sec=seclabel.

I'll make this change if you feel strongly about it though.  :)
