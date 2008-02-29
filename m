Return-Path: <linux-kernel-owner+w=401wt.eu-S1761601AbYB2W6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761601AbYB2W6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 17:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbYB2W6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 17:58:38 -0500
Received: from web36609.mail.mud.yahoo.com ([209.191.85.26]:41427 "HELO
	web36609.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754665AbYB2W6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 17:58:37 -0500
X-YMail-OSG: vPi9MW4VM1lAQX.C3NFCeFz971r6HwbRcfDet1o6cTclI5h70AW6Q38de4rbVutZ01jAOVX_Fw--
X-RocketYMMF: rancidfat
Date: Fri, 29 Feb 2008 14:58:36 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr name
To: Dave Quigley <dpquigl@tycho.nsa.gov>, casey@schaufler-ca.com
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Christoph Hellwig <hch@infradead.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, viro@ftp.linux.org.uk,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <1204323305.2715.134.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <271809.19457.qm@web36609.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Dave Quigley <dpquigl@tycho.nsa.gov> wrote:

> 
> ...
> 
> You need to give me a specific example of why if I have policy A on both
> ends on an SELinux box that a secctx isn't the same on both boxes. 

Trond can, and I'm completely confident he will, correct me if I'm
wrong, but interoperability seems to require that you can't assume
the perfect administration scenario. If you could, the name/value
pair scheme would be perfectly viable, but Trond has very clearly
explained why it is not reasonable to assume that.

But, for early going you may get away with telling people that
the configuration has to be identical. They won't listen and will
mess it up, but you will probably get away with it.



Casey Schaufler
casey@schaufler-ca.com
