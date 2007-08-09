Return-Path: <linux-kernel-owner+w=401wt.eu-S966899AbXHIRHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966899AbXHIRHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934322AbXHIRHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:07:34 -0400
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:22370 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932352AbXHIRHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:07:33 -0400
X-YMail-OSG: Y83vvJUVM1mz0Ol5jLxFCurBc51cfGa7x_BgZTuKNZdd7rwI.to5JezSSKDfy7H8SQ--
X-RocketYMMF: rancidfat
Date: Thu, 9 Aug 2007 10:07:32 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 11/14] CacheFiles: Permit an inode's security ID to be obtained [try #2]
To: David Howells <dhowells@redhat.com>, torvalds@osdl.org, akpm@osdl.org,
       steved@redhat.com, trond.myklebust@fys.uio.no
Cc: linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070809160535.17906.59852.stgit@warthog.cambridge.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <162335.27499.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Permit an inode's security ID to be obtained by the CacheFiles module.  This
> is
> then used as the SID with which files and directories will be created in the
> cache.

This is SELinux specific functionality. It should not be an LSM
interface. 

Casey Schaufler
casey@schaufler-ca.com
