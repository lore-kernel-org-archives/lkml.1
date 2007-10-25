Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbXJYJ4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbXJYJ4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 05:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbXJYJzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 05:55:38 -0400
Received: from main.gmane.org ([80.91.229.2]:52145 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758843AbXJYJzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 05:55:36 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Samuel Tardieu <sam@rfc1149.net>
Subject: Re: Is gcc thread-unsafe?
Date: Thu, 25 Oct 2007 11:54:38 +0200
Message-ID: <87r6jjzfhd.fsf@willow.rfc1149.net>
References: <MDEHLPKNGKAHNMBLJOLKAEOKHLAC.davids@webmaster.com> <200710251447.51370.nickpiggin@yahoo.com.au> <2007-10-25-11-44-28+trackit+sam@rfc1149.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: zaphod.rfc1149.net
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
Cancel-Lock: sha1:Aem1Dm0XI6wIE5iFJi/TSA1N0aY=
X-Leafnode-NNTP-Posting-Host: 2001:6f8:37a:2::2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sam" == Samuel Tardieu <sam@rfc1149.net> writes:
>>>>> "Nick" == Nick Piggin <nickpiggin@yahoo.com.au> writes:

Nick> Either way, I think we really need a way to turn it off for
Nick> Linux.

Sam> Someone would need to add an option to disable the "cselim" pass
Sam> in GCC tree-ssa-phiopt.c as far as I can tell from reading GCC
Sam> source.

Mmm, it looks like there is an option already (-fno-tree-cselim), but
it looks like it has no visible effect in my version of GCC
(yesterday's SVN). I'll ask on the GCC mailing-list.

  Sam
-- 
Samuel Tardieu -- sam@rfc1149.net -- http://www.rfc1149.net/

