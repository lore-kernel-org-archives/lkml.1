Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbYCEA7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbYCEA7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYCEA7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:59:12 -0500
Received: from namei.org ([69.55.235.186]:50141 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753026AbYCEA7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:59:11 -0500
Date: Wed, 5 Mar 2008 11:58:08 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
cc: Casey Schaufler <casey@schaufler-ca.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH BUGFIX -rc3] Smack: Don't register smackfs if we're not
 loaded
In-Reply-To: <alpine.LFD.1.00.0803041009210.12253@woody.linux-foundation.org>
Message-ID: <Xine.LNX.4.64.0803051154180.7427@us.intercode.com.au>
References: <521493.30745.qm@web36606.mail.mud.yahoo.com>
 <alpine.LFD.1.00.0803041009210.12253@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008, Linus Torvalds wrote:

> 
> 
> On Tue, 4 Mar 2008, Casey Schaufler wrote:
> > 
> > One solution would be to tighten the smackfs code so that it
> > handles the uninitialized LSM case properly.
> 
> I really would tend to prefer that.

Can you simply call init_smk_fs() from smack_init() prior to 
register_security() ?


- James
-- 
James Morris
<jmorris@namei.org>
