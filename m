Return-Path: <linux-kernel-owner+w=401wt.eu-S1762298AbXHHGuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762298AbXHHGuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 02:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbXHHGus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 02:50:48 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:39477 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbXHHGur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 02:50:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Sq/srez1FJcx+NLl2TZgiaKG5lkhp2YdiMSgEe+sVC78n0ekd6kyePRa8PnmLk0xCIfIm3w9td2T3xpOse8nJpR6ThFN1rMsNWKNPhlEtGoaqLP9o14mN3QQTdbL+zw9nBXCWhwnNkrYvbN28BTl3zxp9hZlUYkKmnaVigz08y0=
Date: Wed, 8 Aug 2007 15:50:39 +0900
From: Tejun Heo <htejun@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 03/25] sysfs: Use kill_anon_super
Message-ID: <20070808065039.GW13674@htj.dyndns.org>
References: <11860582832964-git-send-email-htejun@gmail.com> <m1643rkqb6.fsf@ebiederm.dsl.xmission.com> <m11wefkq88.fsf_-_@ebiederm.dsl.xmission.com> <m1wsw7jbml.fsf_-_@ebiederm.dsl.xmission.com> <m1sl6vjbjw.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1sl6vjbjw.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 03:10:27PM -0600, Eric W. Biederman wrote:
> 
> Since sysfs no longer stores fs directory information in the dcache
> on a permanent basis kill_litter_super it is inappropriate and actively
> wrong.  It will decrement the count on all dentries left in the
> dcache before trying to free them.
> 
> At the moment this is not biting us only because we never unmount sysfs.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
