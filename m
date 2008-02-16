Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbYBPTHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbYBPTHi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 14:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610AbYBPTHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 14:07:31 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:50412 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482AbYBPTHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 14:07:30 -0500
Date: Sat, 16 Feb 2008 12:07:28 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: SLUB: Increasing partial pages
Message-ID: <20080216190727.GH7657@parisc-linux.org>
References: <20080116195949.GO18741@parisc-linux.org> <Pine.LNX.4.64.0801161219050.9694@schroedinger.engr.sgi.com> <20080116214127.GA11559@parisc-linux.org> <Pine.LNX.4.64.0801161347160.11353@schroedinger.engr.sgi.com> <20080116221618.GB11559@parisc-linux.org> <Pine.LNX.4.64.0801161421240.12024@schroedinger.engr.sgi.com> <20080118191430.GD20490@parisc-linux.org> <Pine.LNX.4.64.0801221142330.27692@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801221142330.27692@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 12:00:00PM -0800, Christoph Lameter wrote:
> Patches that I would recommend to test individually if you could do it 
> (get the series via git pull 
> git://git.kernel.org/pub/scm/linux/kernel/git/christoph/vm.git performance):

With these patches applied to 2.6.24-rc8, the perf team are seeing
oopses while running the benchmark.  They're currently trying to narrow
down which of the patches it is.  I'll get an oops for you to study when
they've figured that out.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
