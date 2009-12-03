Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748AbZLCAIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbZLCAIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 19:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbZLCAIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 19:08:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548AbZLCAIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 19:08:37 -0500
Message-ID: <4B170174.5030805@redhat.com>
Date: Thu, 03 Dec 2009 08:08:20 +0800
From: Eugene Teo <eteo@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Casey Dahlin <cdahlin@redhat.com>
CC: linux-kernel@vger.kernel.org, "Bryn M. Reeves" <bmr@redhat.com>,
       Neela Syam Kolli <megaraidlinux@lsi.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yang Hongyang <yanghy@cn.fujitsu.com>, Anand Gadiyar <gadiyar@ti.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] [SCSI] megaraid_sas: remove sysfs dbg_lvl world writeable
 permissions
References: <1259767064-13738-1-git-send-email-cdahlin@redhat.com>
In-Reply-To: <1259767064-13738-1-git-send-email-cdahlin@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2009 11:17 PM, Casey Dahlin wrote:
> From: Bryn M. Reeves<bmr@redhat.com>
>
> /sys/bus/pci/drivers/megaraid_sas/poll_mode_io defaults to being
> world-writable, which seems bad (letting any user affect kernel driver
> behavior).
>
> This turns off group and user write permissions, so that on typical
> production systems only root can write to it.
>
> Signed-off-by: Bryn M. Reeves<bmr@redhat.com>
> Signed-off-by: Casey Dahlin<cdahlin@redhat.com>

CC: Eugene Teo <eteo@redhat.com>

The subject should read: megaraid_sas: remove poll_mode_io world 
writeable permissions instead, and this has been assigned with 
CVE-2009-3939.

Thanks, Eugene
-- 
Eugene Teo / Red Hat Security Response Team
