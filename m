Return-Path: <linux-kernel-owner+w=401wt.eu-S1760157AbYC0QCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbYC0QCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 12:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756721AbYC0QCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 12:02:23 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:61178 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581AbYC0QCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 12:02:22 -0400
Date: Thu, 27 Mar 2008 08:58:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroups: devices: add Documentation/ file
Message-Id: <20080327085837.c51ebe6d.randy.dunlap@oracle.com>
In-Reply-To: <20080327151227.GA11581@sergelap.austin.ibm.com>
References: <20080327151227.GA11581@sergelap.austin.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008 10:12:27 -0500 Serge E. Hallyn wrote:

> Fill a Documentation/controllers/devices.txt file with a
> modified text from the patch description.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> ---
>  Documentation/controllers/devices.txt |   48 +++++++++++++++++++++++++++++++++
>  1 files changed, 48 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/controllers/devices.txt
> 
> diff --git a/Documentation/controllers/devices.txt b/Documentation/controllers/devices.txt
> new file mode 100644
> index 0000000..a157f53
> --- /dev/null
> +++ b/Documentation/controllers/devices.txt
> @@ -0,0 +1,48 @@
> +Device Whitelist Controller
> +
> +1. Description:
> +

...

> +The root device cgroup starts with rwm to 'all'.  A child devices

                                                             device's

> +cgroup gets a copy of the parent.  Administrators can then remove
> +devices from the whitelist or add new entries.  A child cgroup can
> +never receive a device access which is denied its parent.  However
> +when a device access is removed from a parent it will not also be
> +removed from the child(ren).
> +
> +2. User Interface
> +
...
> +
> +3. Security
> +
> +Any task can move itself between cgroups.  This of clearly won't

s/of//

> +suffice, but we can decide the best way to adequately restrict
> +movement as people get some experience with this.  We may just want
> +to require CAP_SYS_ADMIN, which at least is a separate bit from
> +CAP_MKNOD.  We may want to just refuse moving to a cgroup which
> +isn't a descendent of the current one.  Or we may want to use
> +CAP_MAC_ADMIN, since we really are trying to lock down root.
> +
> +CAP_SYS_ADMIN is needed to modify the whitelist or move another
> +task to a new cgroup.  (Again we'll probably want to change that).
> +
> +A cgroup may not be granted more permissions than the cgroup's
> +parent has.  
> -- 

---
~Randy
