Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbZG2Q5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbZG2Q5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 12:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbZG2Q5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 12:57:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33400 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755881AbZG2Q5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 12:57:52 -0400
Message-ID: <4A707F85.5090008@redhat.com>
Date: Wed, 29 Jul 2009 18:57:41 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Paul Clements <paul.clements@steeleye.com>
CC: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>,
       kernel list <linux-kernel@vger.kernel.org>, ian.campbell@citrix.com
Subject: Re: [BUG] raid1 behind writes alter bio structure illegally
References: <4A707578.3010901@steeleye.com>
In-Reply-To: <4A707578.3010901@steeleye.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Paul Clements wrote:
> I've run into this bug on a 2.6.18 kernel, but I think the fix is still 
> applicable to the latest kernels (even though the symptoms would be 
> slightly different).
> 
> Perhaps someone who knows the block and/or SCSI layers well can comment 
> on the legality of attaching new pages to a bio without fixing up the 
> internal bio counters (details below)?

> LVM over raid1 over SCSI/nbd

Please can you try that backporting of this patch helps?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5d84070ee0a433620c57e85dac7f82faaec5fbb3

(If so, see https://bugzilla.redhat.com/show_bug.cgi?id=512387)

Milan
--
mbroz@redhat.com

