Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbZEUSMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbZEUSMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 14:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbZEUSM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 14:12:29 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:36909 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbZEUSM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 14:12:28 -0400
Subject: Re: 2.6.29+ NFS-Server Problem "reconnect_path: npd != pd"
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Sven Geggus <lists@fuchsschwanzdomain.de>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
In-Reply-To: <gv4463$6fn$1@ultimate100.geggus.net>
References: <20090521142026.GA5566@geggus.net>
	 <1242924599.6687.1.camel@heimdal.trondhjem.org>
	 <20090521165751.GA4428@geggus.net>
	 <1242927133.6687.4.camel@heimdal.trondhjem.org>
	 <gv4463$6fn$1@ultimate100.geggus.net>
Content-Type: text/plain
Date: Thu, 21 May 2009 14:12:26 -0400
Message-Id: <1242929546.22947.11.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 4 sum msgs/h 1 total rcpts 398 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=_URIID_)
X-UiO-Scanned: 24B73299BCEAD6C48076409638D04EE97AC82846
X-UiO-SPAM-Test: remote_host: 71.227.91.12 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 300 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-21 at 17:48 +0000, Sven Geggus wrote:
> Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
> > So what is the underlying filesystem that you are exporting, and what
> > does your /etc/exports file look like?
> 
> The underlying filesystem is xfs and /etc/exports (unchanged) is here:
> 
> --cut--
> # /etc/exports: the access control list for filesystems which may be exported
> #		to NFS clients.  See exports(5).
> /               192.168.3.2(rw,no_root_squash,async,subtree_check)
> /home/sven	192.168.3.2(rw,no_root_squash,async,subtree_check) 192.168.3.6(rw,no_root_squash,async,subtree_check) 192.168.3.8(rw,no_root_squash,async,subtree_check)
> /home/mp3	192.168.3.2(rw,no_root_squash,async,subtree_check) 192.168.3.6(rw,no_root_squash,async,subtree_check) 192.168.3.8(rw,no_root_squash,async,subtree_check)
> /home/sven/filme 192.168.3.7(ro,async,subtree_check)
> /home/kathi910	192.168.3.7(rw,no_root_squash,async,no_subtree_check)
> --cut--
> 
> 192.168.3.2 is the client which causes the error, I didn't notice the
> error on the other clients, but they are not used that often.
> 
> Especially 192.168.3.7 does seem to work.
> 
> Regards
> 
> Sven
> 

Reforwarding the reply for the benefit of the NFS mailing list. Not
everyone reads lkml...

Trond

