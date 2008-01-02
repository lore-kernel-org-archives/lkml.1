Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbYABNGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbYABNGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 08:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYABNGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 08:06:11 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:42840 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbYABNGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 08:06:10 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <477B8C2D.2040702@s5r6.in-berlin.de>
Date: Wed, 02 Jan 2008 14:05:49 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Dave Young <hidave.darkstar@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: The perfect patch - Posting a patch series
References: <20071229011057.GG2883@darkstar.te-china.tietoenator.com>  <20071229025506.GL11638@parisc-linux.org>  <477632A7.6050208@s5r6.in-berlin.de> <a8e1da0801011829p15da81dcw9db0f7cbb5444467@mail.gmail.com> <477B7219.4080508@s5r6.in-berlin.de> <Pine.LNX.4.64.0801021238450.14900@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0801021238450.14900@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> And [0/n] sometimes contain a diffstat which gives an approximate
> line count of how big the patchset actually is.

There is actually no good reason for omitting such a diffstat.  It's
easy enough to generate.

$ quilt diff --combine first.patch -P last.patch | diffstat -p1 -w72

$ git diff --stat=72 --summary -M commit_before_first_patch..last_commit
-- 
Stefan Richter
-=====-==--- ---= ---=-
http://arcgraph.de/sr/
