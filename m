Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbYLPMLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbYLPMLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 07:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbYLPMLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 07:11:05 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:56836 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbYLPMLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 07:11:04 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49479AC4.7000901@s5r6.in-berlin.de>
Date: Tue, 16 Dec 2008 13:10:44 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: Sitaram Chamarty <sitaramc@gmail.com>
CC: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       devzero@web.de
Subject: Re: problem with git.kernel.org
References: <543076374@web.de> <49465862.9090400@s5r6.in-berlin.de> <gi5vbm$tts$1@ger.gmane.org>
In-Reply-To: <gi5vbm$tts$1@ger.gmane.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sitaram Chamarty wrote:
> On 2008-12-15, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> 
>> Chris, you should enable fetching over http by
>> $ cd /pub/scm/linux/kernel/git/mason/btrfs-unstable-standalone.git
>> $ cp -p hooks/post-update.sample hooks/post-update
> 
> I notice that the .git/hooks/post-update still calls it
> "git-update-server-info".  Shouldn't that be "git
> update-server-info"?

Well, OK, it needs to be "git foo" in manual invocation.  The
.git/hooks/ may continue to call "git-foo" because they have the
necessary directory in their $PATH.
-- 
Stefan Richter
-=====-==--- ==-- =----
http://arcgraph.de/sr/
