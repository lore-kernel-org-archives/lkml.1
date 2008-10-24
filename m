Return-Path: <linux-kernel-owner+w=401wt.eu-S1752106AbYJXEtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbYJXEtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbYJXEj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:39:58 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:47137 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbYJXEj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:39:57 -0400
From: Andrey Mirkin <major@openvz.org>
To: devel@openvz.org
Subject: Re: [Devel] Re: [PATCH 05/10] Introduce function to dump process
Date: Fri, 24 Oct 2008 08:40:16 +0400
User-Agent: KMail/1.8.2
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1224285098-573-1-git-send-email-major@openvz.org> <1224285098-573-6-git-send-email-major@openvz.org> <20081020174801.GB29092@us.ibm.com>
In-Reply-To: <20081020174801.GB29092@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810240840.17531.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 October 2008 21:48 Serge E. Hallyn wrote:
> Quoting Andrey Mirkin (major@openvz.org):
> > +	t->cpt_uid = tsk->uid;
> > +	t->cpt_euid = tsk->euid;
> > +	t->cpt_suid = tsk->suid;
> > +	t->cpt_fsuid = tsk->fsuid;
> > +	t->cpt_gid = tsk->gid;
> > +	t->cpt_egid = tsk->egid;
> > +	t->cpt_sgid = tsk->sgid;
> > +	t->cpt_fsgid = tsk->fsgid;
>
> I don't see where any of these are restored.  (Obviously, I wanted
> to think about how you're verifying the restarter's authorization
> to do so)

Well, right now I don't use them during restore to simplify restart procedure 
and make it more clear for reviewers. In OpenVZ we are doing all restart 
procedure with root's privileges and relying on fact that all such IDs will 
be the same during restart (as we are restarting a container and its file 
system will be the same during restart).

Andrey
