Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbYAHTPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbYAHTPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbYAHTP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:15:29 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38002 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573AbYAHTP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:15:27 -0500
Subject: Re: [patch 5/9] unprivileged mounts: allow unprivileged bind mounts
From: Dave Hansen <haveblue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, ebiederm@xmission.com, kzak@redhat.com,
       linux-fsdevel@vger.kernel.org, containers@lists.osdl.org,
       util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <E1JCJoQ-0003g9-Nk@pomaz-ex.szeredi.hu>
References: <20080108113502.184459371@szeredi.hu>
	 <20080108113626.895583537@szeredi.hu> <1199815958.9834.58.camel@localhost>
	 <E1JCJoQ-0003g9-Nk@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 11:15:10 -0800
Message-Id: <1199819710.9834.74.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-08 at 20:08 +0100, Miklos Szeredi wrote:
> 
> The logic behind EPERM, is that this failure is only for unprivileged
> callers.  ENOMEM is too specifically about OOM.  It could be changed
> to ENOSPC, ENFILE, EMFILE, or it could remain EPERM.  What do others
> think? 

Since you're patching mount anyway, maybe you could add a little pointer
for people to go check the sysctl if they get a certain error code back
from here.

-- Dave

