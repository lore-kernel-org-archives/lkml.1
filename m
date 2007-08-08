Return-Path: <linux-kernel-owner+w=401wt.eu-S1760337AbXHHIkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760337AbXHHIkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 04:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbXHHIkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 04:40:04 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:46213 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbXHHIkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 04:40:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ro96WF0frmguEOLUKmhnw0HcjDky6ax6TYAkolTtks26n3ft0c6mLBaPUJIfrpE6qNwfg0wfnq2+xoDDTQagYi6vNZSUV4OCqb9H4tAB3tmSwcmakAQH+vL2HKf1fJR6ETD78lJOm57FxcMGzbSkgG8GPcS6CEg901uyW++bLtQ=
Date: Wed, 8 Aug 2007 17:39:53 +0900
From: Tejun Heo <htejun@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 15/25] vfs: Remove lookup_one_len_kern
Message-ID: <20070808083953.GH13674@htj.dyndns.org>
References: <m1fy2vjbf9.fsf_-_@ebiederm.dsl.xmission.com> <m1bqdjjbcf.fsf_-_@ebiederm.dsl.xmission.com> <m17io7jba4.fsf_-_@ebiederm.dsl.xmission.com> <m13ayvjb82.fsf_-_@ebiederm.dsl.xmission.com> <m1y7gnhwm4.fsf_-_@ebiederm.dsl.xmission.com> <m1tzrbhwkc.fsf_-_@ebiederm.dsl.xmission.com> <m1ps1zhwhp.fsf_-_@ebiederm.dsl.xmission.com> <m1lkcnhwfu.fsf_-_@ebiederm.dsl.xmission.com> <m1hcnbhwcy.fsf_-_@ebiederm.dsl.xmission.com> <m1d4xzhwb2.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d4xzhwb2.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 03:25:05PM -0600, Eric W. Biederman wrote:
> 
> Now that sysfs no longer uses lookup_one_len_kern the function has
> no users so remove it from the kernel.  Making namei.c just a little
> easier to read.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Oh.. you're killing lookup_one_len_kern().  In that case, I think the
previous one is okay too.

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
