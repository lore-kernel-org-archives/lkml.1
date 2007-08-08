Return-Path: <linux-kernel-owner+w=401wt.eu-S1762105AbXHHIxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762105AbXHHIxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 04:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbXHHIxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 04:53:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:64802 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbXHHIxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 04:53:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=A4ldcQnyIqA1APaYcqmiZseAxU2CD8MZUuatbU0EQY3YU4MCIG8curMtsiv2QyEW/XxTcpCwWynJbgcvAE0lt5Fh9gE75RVL1tG3lFBvNiK/ZeM4bbevaGLn5Bia8iYFItOV8ct5QgpLfEBto/FNgbeatKmePVHcYill4InMSlc=
Date: Wed, 8 Aug 2007 17:53:04 +0900
From: Tejun Heo <htejun@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 18/25] sysfs: Rewrite sysfs_move_dir in terms of sysfs dirents
Message-ID: <20070808085304.GJ13674@htj.dyndns.org>
References: <m13ayvjb82.fsf_-_@ebiederm.dsl.xmission.com> <m1y7gnhwm4.fsf_-_@ebiederm.dsl.xmission.com> <m1tzrbhwkc.fsf_-_@ebiederm.dsl.xmission.com> <m1ps1zhwhp.fsf_-_@ebiederm.dsl.xmission.com> <m1lkcnhwfu.fsf_-_@ebiederm.dsl.xmission.com> <m1hcnbhwcy.fsf_-_@ebiederm.dsl.xmission.com> <m1d4xzhwb2.fsf_-_@ebiederm.dsl.xmission.com> <m18x8nhw8r.fsf_-_@ebiederm.dsl.xmission.com> <m14pjbhw6y.fsf_-_@ebiederm.dsl.xmission.com> <m1zm13ghlh.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zm13ghlh.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 03:28:10PM -0600, Eric W. Biederman wrote:
> 
> This patch rewrites sysfs_move_dir to perform it's checks
> as much as possible on the underlying sysfs_dirents instead
> of the contents of the dcache, making sysfs_move_dir
> more like the rest of the sysfs directory modification
> code.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
