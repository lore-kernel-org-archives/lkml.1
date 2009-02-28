Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbZB1Rdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbZB1Rdu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 12:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbZB1Rdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 12:33:40 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43488 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbZB1Rdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 12:33:40 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49A97563.6040906@s5r6.in-berlin.de>
Date: Sat, 28 Feb 2009 18:33:23 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
CC: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
References: <1235757920-20474-1-git-send-email-broonie@sirena.org.uk> <49A942F6.3020600@s5r6.in-berlin.de> <20090228155841.GA15127@sirena.org.uk> <49A962F8.30609@s5r6.in-berlin.de> <20090228164627.GC15127@sirena.org.uk>
In-Reply-To: <20090228164627.GC15127@sirena.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> It is apparent that they do not consider
> the subject line of the e-mail (which is the first line of the changelog
> if you're using git) to be part of the changelog.

This really surprises me.  ^Subject: .+$ is the title of the log and
thereby its first part.  Also, I don't see a connection to git.  I
manage patches with quilt and never loose patch titles.  I still think
you should count ^Subject: .+$ too if you want to check for presence of
a changelog.

Sometimes I see patch postings with the title appearing twice; I always
thought these were beginners' mistakes and a nuisance when importing a
patch.

(PS:  Granted, many patches come with poorly written changelogs; I
struggle with it in my own patches all the time too.  But it's something
which checkpatch just cannot check.)
-- 
Stefan Richter
-=====-==--= --=- ===--
http://arcgraph.de/sr/
