Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbZBYRx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbZBYRx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 12:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757043AbZBYRxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 12:53:46 -0500
Received: from zombie2.ncsc.mil ([144.51.88.133]:60900 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116AbZBYRxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 12:53:45 -0500
Subject: Re: [RFC 0/8] Aufs2 documents
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hooanon05@yahoo.co.jp
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <7558.1235374266@jrobl>
References: <7558.1235374266@jrobl>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 25 Feb 2009 12:50:54 -0500
Message-Id: <1235584254.15148.86.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think it would be useful to see the source code for AUFS2 posted to
LKML. One of the questions I have not which doesn't seem to be addressed
in these documents is how robust is your xattr support and are you
making the appropriate LSM calls to make this usable with SELinux and
Smack. Also from a labeling perspective you have a very interesting
question of which label do you select when unifying directories. If you
have a/foo and b/foo each with different labels which do you choose.
Based on the history of Union type file systems I would suspect the
answer is whichever branch is listed first. 

Dave

