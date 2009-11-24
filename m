Return-Path: <linux-kernel-owner+w=401wt.eu-S932184AbZKXH6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbZKXH6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 02:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757848AbZKXH6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 02:58:23 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:49608 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757840AbZKXH6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 02:58:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=QRjYaZfKWNUyAkFwhP606ph+bSezoD81L0JTC9SFLpxdo1hyfYUHfEZfAO66KpnSwV
         92fKRTu5m5JvJcLF5a8TRU8X2NGiypB2+W2LI+R2sNPWVjq5IrlflKRfr3KjVTCG1AmV
         F98B9iQ0iC38hW8GB8zXrJ13FFubkA2AjhaWM=
Date: Tue, 24 Nov 2009 09:58:13 +0200
From: Dan Carpenter <error27@gmail.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org, Andi Kleen <andi@firstfloor.org>,
       Neil Horman <nhorman@redhat.com>
Subject: Re: [Resend Patch] kexec: allow to shrink reserved memory
Message-ID: <20091124075813.GA14488@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	akpm@linux-foundation.org, Andi Kleen <andi@firstfloor.org>,
	Neil Horman <nhorman@redhat.com>
References: <20091123093958.4963.38592.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091123093958.4963.38592.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 04:37:02AM -0500, Amerigo Wang wrote:
[snip]
> +size_t crash_get_memory_size(void);
[snip]
> +static ssize_t kexec_crash_size_show(struct kobject *kobj,
> +				       struct kobj_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "%lu\n", crash_get_memory_size());
> +}

  CC      kernel/ksysfs.o
kernel/ksysfs.c: In function ‘kexec_crash_size_show’:
kernel/ksysfs.c:106: warning: format ‘%lu’ expects type ‘long unsigned int’, but argument 3 has type ‘size_t’

Could we get suppress this gcc warning?

regards,
dan carpenter
