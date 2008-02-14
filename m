Return-Path: <linux-kernel-owner+w=401wt.eu-S934415AbYBNAPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934415AbYBNAPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932131AbYBNAP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:15:29 -0500
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:42921 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531AbYBNAP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:15:26 -0500
To: Jeff Layton <jlayton@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org
Subject: Re: Upgrade to 2.6.24 breaks NFS service
References: <87lk5pjkro.fsf@hades.wkstn.nix>
	<20080213021912.b127c4a7.akpm@linux-foundation.org>
	<20080213075738.086f7b32@barsoom.rdu.redhat.com>
From: Nix <nix@esperi.org.uk>
Emacs: ... it's not just a way of life, it's a text editor!
Date: Thu, 14 Feb 2008 00:14:50 +0000
In-Reply-To: <20080213075738.086f7b32@barsoom.rdu.redhat.com> (Jeff Layton's message of "Wed, 13 Feb 2008 07:57:38 -0500")
Message-ID: <878x1ojsw5.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-sonic.net-Metrics: hades 1117; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 Feb 2008, Jeff Layton told this:

> If upgrading nfs-utils doesn't help, on this box, could you run:
>
> # rpcinfo -p localhost
>
> send the output? statd expects that lockd will always be listening on a
> UDP socket and some changes recently made it so that when there are
> only TCP mounts that it doesn't necessarily do so. That may be the
> problem here.

I rebooted back into 2.6.24.2 again, and everything works now, without
even upgrading nfs-utils (although I did that anyway, to nfs-utils git
head, and it's still happy).

Linux: debugs itself, no human intervention required! :)



(The inconsistency of this screams `port allocation' to me. If it
happens again I'll get some rpcinfo output and packet dumps. I'd
have done it this time if it hadn't been for the plug-the-security-
hole rush and it being 2am.)

-- 
`The rest is a tale of post and counter-post.' --- Ian Rawlings
                                                   describes USENET
