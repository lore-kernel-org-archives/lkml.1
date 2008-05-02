Return-Path: <linux-kernel-owner+w=401wt.eu-S1764634AbYEBAgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764634AbYEBAgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 20:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765436AbYEBAfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 20:35:36 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:35031 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764591AbYEBAfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 20:35:34 -0400
Message-ID: <481A61A7.6050305@kernel.org>
Date: Thu, 01 May 2008 17:34:47 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] capabilities: add bounding set to /proc/self/status
References: <20080501183559.GA21279@sergelap.austin.ibm.com>
In-Reply-To: <20080501183559.GA21279@sergelap.austin.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Acked-by: Andrew G. Morgan <morgan@kernel.org>

Cheers

Andrew

Serge E. Hallyn wrote:
| There is currently no way to query the bounding set of another
| task.  As there appears to be no security reason not to, and
| as Michael Kerrisk points out the following valid reasons to do
| so exist:
|
| * consistency (I can see all of the other per-thread/process sets in
| /proc/.../status)
| * debugging -- I could imagine that it would make the job of debugging
| an application that uses capabilities a little simpler.
|
| this patch adds the bounding set to /proc/self/status right after
| the effective set.
|
| If at all possible (and if acked by Andrew Morgan) it would be nice to
| get this into the 2.6.26 cycle.  But I realize it probably is too late
| for that.
|
| Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
| Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
| ---
|  fs/proc/array.c |    1 +
|  1 files changed, 1 insertions(+), 0 deletions(-)
|
| diff --git a/fs/proc/array.c b/fs/proc/array.c
| index c135cbd..160dd4a 100644
| --- a/fs/proc/array.c
| +++ b/fs/proc/array.c
| @@ -297,6 +297,7 @@ static inline void task_cap(struct seq_file *m,
struct task_struct *p)
|  	render_cap_t(m, "CapInh:\t", &p->cap_inheritable);
|  	render_cap_t(m, "CapPrm:\t", &p->cap_permitted);
|  	render_cap_t(m, "CapEff:\t", &p->cap_effective);
| +	render_cap_t(m, "CapBnd:\t", &p->cap_bset);
|  }
|
|  static inline void task_context_switch_counts(struct seq_file *m,
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFIGmGn+bHCR3gb8jsRAlufAJ0eheUXQ1xvB8HofY3KbPIUHqSUXQCeOQf2
pZBx38zkUe7nviE7Z77ns3k=
=lPd5
-----END PGP SIGNATURE-----
