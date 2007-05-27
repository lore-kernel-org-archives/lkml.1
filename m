Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbXE0JF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbXE0JF1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 05:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbXE0JFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 05:05:07 -0400
Received: from fep07.mfe.bur.connect.com.au ([203.63.86.27]:47829 "EHLO
	fep07.mfe.bur.connect.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798AbXE0JFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 05:05:05 -0400
X-Greylist: delayed 1691 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 May 2007 05:05:04 EDT
Message-ID: <46594282.8010307@iinet.net.au>
Date: Sun, 27 May 2007 16:34:10 +0800
From: Cliffe <cliffe@iinet.net.au>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: casey@schaufler-ca.com, Andreas Gruenbacher <agruen@suse.de>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM
 hook
References: <309300.41401.qm@web36615.mail.mud.yahoo.com> <B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com>
In-Reply-To: <B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 >> On the other hand, if you actually want to protect the _data_, then 
tagging the _name_ is flawed; tag the *DATA* instead.

Would it make sense to label the data (resource) with a list of paths 
(names) that can be used to access it?

Therefore the data would be protected against being accessed via 
alternative arbitrary names. This may be a simple label to maintain and 
(possibly to) enforce, allowing path based confinement to protect a 
resource. This may allow for the benefits of pathname based confinement 
while avoiding some of its problems.

Obviously this would not protect against a pathname pointing to 
arbitrary data…


Just a thought.

Z. Cliffe Schreuders.


