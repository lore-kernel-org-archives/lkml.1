Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbZEURs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbZEURs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 13:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbZEURsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 13:48:52 -0400
Received: from nerdhammel.gnuher.de ([88.198.0.170]:32891 "EHLO
	nerdhammel.gnuher.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbZEURsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 13:48:51 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: Sven Geggus <lists@fuchsschwanzdomain.de>
Subject: Re: 2.6.29+ NFS-Server Problem "reconnect_path: npd != pd"
Date: Thu, 21 May 2009 17:48:51 +0000 (UTC)
Organization: Geggus clan, virtual section
Message-ID: <gv4463$6fn$1@ultimate100.geggus.net>
References: <20090521142026.GA5566@geggus.net> <1242924599.6687.1.camel@heimdal.trondhjem.org> <20090521165751.GA4428@geggus.net> <1242927133.6687.4.camel@heimdal.trondhjem.org>
NNTP-Posting-Host: diesel.geggus.net
X-Trace: ultimate100.geggus.net 1242928131 6647 192.168.3.2 (21 May 2009 17:48:51 GMT)
X-Complaints-To: usenet@geggus.net
NNTP-Posting-Date: Thu, 21 May 2009 17:48:51 +0000 (UTC)
Cancel-Lock: sha1:GNMHM+a0Fdyv2/Nm1jJZhYQlBAU=
X-TERMINAL: rxvt-unicode
X-OS: Debian GNU/Linux (Kernel 2.6.29.3)
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.29.3 (i686))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> So what is the underlying filesystem that you are exporting, and what
> does your /etc/exports file look like?

The underlying filesystem is xfs and /etc/exports (unchanged) is here:

--cut--
# /etc/exports: the access control list for filesystems which may be exported
#		to NFS clients.  See exports(5).
/               192.168.3.2(rw,no_root_squash,async,subtree_check)
/home/sven	192.168.3.2(rw,no_root_squash,async,subtree_check) 192.168.3.6(rw,no_root_squash,async,subtree_check) 192.168.3.8(rw,no_root_squash,async,subtree_check)
/home/mp3	192.168.3.2(rw,no_root_squash,async,subtree_check) 192.168.3.6(rw,no_root_squash,async,subtree_check) 192.168.3.8(rw,no_root_squash,async,subtree_check)
/home/sven/filme 192.168.3.7(ro,async,subtree_check)
/home/kathi910	192.168.3.7(rw,no_root_squash,async,no_subtree_check)
--cut--

192.168.3.2 is the client which causes the error, I didn't notice the
error on the other clients, but they are not used that often.

Especially 192.168.3.7 does seem to work.

Regards

Sven

-- 
"We don't know the OS that God uses, but the Vatican uses Linux"
                               (Sister Judith Zoebelein, Vatican Webmaster)

/me is giggls@ircnet, http://sven.gegg.us/ on the Web
