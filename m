Return-Path: <linux-kernel-owner+w=401wt.eu-S1758545AbYAFRah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545AbYAFRah (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 12:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbYAFRa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 12:30:27 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58831 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698AbYAFRa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 12:30:26 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47811004.6070307@s5r6.in-berlin.de>
Date: Sun, 06 Jan 2008 18:29:40 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
References: <20080102162534.GA4041@elte.hu> <1199292381.3258.32.camel@localhost.localdomain> <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org> <20080102194030.GC11638@parisc-linux.org> <1199304735.3258.53.camel@localhost.localdomain> <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org> <1199316785.3258.85.camel@localhost.localdomain> <alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org> <m3ir27oe7f.fsf@telia.com> <1199627875.5205.1.camel@localhost.localdomain> <20080106144706.GA25419@elte.hu>
In-Reply-To: <20080106144706.GA25419@elte.hu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> If lkml traffic is too big then i'd suggest to set up email 
> filters to separate out mails that have 'SCSI' in their subject line

Good idea.  Minor flaw:  If somebody forgets to Cc LSML, he might also
forget to put SCSI or scsi into the Subject.

> or body.

This yields false positives whenever a .config is posted.

Also, filtering based on message body contents is costlier than
filtering by headers.  I for one use Sieve to sort mails into different
IMAP folders at my mail provider's server, and I think Sieve doesn't
offer tests for patterns in message bodies at all.
-- 
Stefan Richter
-=====-==--- ---= --==-
http://arcgraph.de/sr/
