Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbXLKWgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbXLKWgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbXLKWgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:36:39 -0500
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:63547 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbXLKWgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:36:38 -0500
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2007 17:36:37 EST
From: Junio C Hamano <junio@pobox.com>
To: Divy Le Ray <divy@chelsio.com>
Subject: Re: [PATCH 2/2] cxgb3 - Parity initialization for T3C adapters
References: <20071205181527.22106.73134.stgit@speedy5>
	<4759A6EA.1050106@garzik.org> <4759CD92.2070604@chelsio.com>
cc: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, swise@opengridcomputing.com,
       wenxiong@us.ibm.com
Date: Tue, 11 Dec 2007 14:27:55 -0800
In-Reply-To: <4759CD92.2070604@chelsio.com> (Divy Le Ray's message of "Fri, 07
	Dec 2007 14:47:46 -0800")
Message-ID: <7vbq8wdfys.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Divy Le Ray <divy@chelsio.com> writes:

> On this topic, I have a question: how do I get to see all the
> netdev-2.6 branches ?
> After cloning a free  netdev-2.6 tree, 'git branch' shows only the
> master branch:
> ...
> Cloning
> "git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git"
> into "netdev-2.6-fresh"...
> Initialized empty Git repository in /opt/sources/netdev-2.6-fresh/.git/
> ...
> 100% (23058/23058) done
> done
> -bash-3.1$ cd netdev-2.6-fresh/
> -bash-3.1$ git branch
> * master

At this point,

$ git branch -r

will show you have copies of Jeff's branches in remotes/origin/.

$ git checkout -b upstream origin/upstream

would make your local upstream branch that forks from Jeff's upstream
branch.
