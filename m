Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbXDVArj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbXDVArj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 20:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbXDVArj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 20:47:39 -0400
Received: from cs.columbia.edu ([128.59.16.20]:58801 "EHLO cs.columbia.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883AbXDVAri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 20:47:38 -0400
Message-ID: <462AB061.2070104@cs.columbia.edu>
Date: Sat, 21 Apr 2007 20:46:25 -0400
From: Shaya Potter <spotter@cs.columbia.edu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Miklos Szeredi <miklos@szeredi.hu>, serue@us.ibm.com,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com, ebiederm@xmission.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [patch 7/8] allow unprivileged mounts
References: <20070420102532.385211890@szeredi.hu>	<20070420102652.075606533@szeredi.hu> <20070421005513.e230aa88.akpm@linux-foundation.org>
In-Reply-To: <20070421005513.e230aa88.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PerlMx-Spam: Gauge=IIIIIII, Probability=7%, X-Seen-By filter1.cs.columbia.edu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 20 Apr 2007 12:25:39 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
>> Define a new fs flag FS_SAFE, which denotes, that unprivileged
>> mounting of this filesystem may not constitute a security problem.
>>
>> Since most filesystems haven't been designed with unprivileged
>> mounting in mind, a thorough audit is needed before setting this flag.
> 
> Practically speaking, is there any realistic likelihood that any filesystem
> apart from FUSE will ever use this?

Would it be interesting to support mounting of external file systems (be 
it USB, NFS or whatever) in a way that automatically forces it to ignore 
suid and devices (which are already mount time options)?   The question 
I guess is, how much do you gain over a setuid program (hack?) that can 
handle this?
