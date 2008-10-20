Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbYJTRs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbYJTRs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYJTRsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:48:20 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58221 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbYJTRsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:48:20 -0400
Date: Mon, 20 Oct 2008 12:48:01 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrey Mirkin <major@openvz.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 05/10] Introduce function to dump process
Message-ID: <20081020174801.GB29092@us.ibm.com>
References: <1224285098-573-1-git-send-email-major@openvz.org> <1224285098-573-2-git-send-email-major@openvz.org> <1224285098-573-3-git-send-email-major@openvz.org> <1224285098-573-4-git-send-email-major@openvz.org> <1224285098-573-5-git-send-email-major@openvz.org> <1224285098-573-6-git-send-email-major@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224285098-573-6-git-send-email-major@openvz.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrey Mirkin (major@openvz.org):
> +	t->cpt_uid = tsk->uid;
> +	t->cpt_euid = tsk->euid;
> +	t->cpt_suid = tsk->suid;
> +	t->cpt_fsuid = tsk->fsuid;
> +	t->cpt_gid = tsk->gid;
> +	t->cpt_egid = tsk->egid;
> +	t->cpt_sgid = tsk->sgid;
> +	t->cpt_fsgid = tsk->fsgid;

I don't see where any of these are restored.  (Obviously, I wanted
to think about how you're verifying the restarter's authorization
to do so)

thanks,
-serge
