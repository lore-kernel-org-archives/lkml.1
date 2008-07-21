Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbYGUOY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbYGUOY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 10:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbYGUOYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 10:24:13 -0400
Received: from slackware.com ([64.57.102.34]:56858 "EHLO bob.slackware.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755127AbYGUOYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 10:24:11 -0400
Date: Mon, 21 Jul 2008 07:23:37 -0700 (PDT)
From: Piter PUNK <piterpunk@slackware.com>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Regression: kernel 2.6.24{,.1} ahci problem, does not boot
In-Reply-To: <487B5230.8040903@kernel.org>
Message-ID: <Pine.LNX.4.63.0807210708320.18468@bob.slackware.com>
References: <Pine.LNX.4.63.0806141945270.2761@bob.slackware.com>
 <487B403F.5040704@gmail.com> <487B5230.8040903@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008, Tejun Heo wrote:

> Tejun Heo wrote:
> Tested a bit more and the problem doesn't seem to be PMP support itself.
> Command issue doesn't work properly if follow up SRST is issued without
> clearing SError after issuing hardreset.  2.6.26 always clears SError
> after hardreset so it should work.  Piter, can you please remove SIS
> blacklist and test 2.6.26?

Removed 1039:1185 from blacklist; PMP is active and all is working
fine. You can remove the 1039:1185 from pmp blacklist (and probably
the other two cards there...).

Need dmesg or other additional information?

Thanks!

Piter PUNK
