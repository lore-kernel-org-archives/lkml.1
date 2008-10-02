Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYJBVZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYJBVZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 17:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbYJBVZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 17:25:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:29113 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbYJBVZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 17:25:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=xNWeYCmQ+tM3tTRJn3rtg1Nd5t/4BYZqOoCI76Ij5tUTfFfrL3oL2CoxU2c64C4XW2
         yN5sM1bYb9MAjuSDJi8B4a6JQK+RGA8ezIChRh6/otBQcdCU/HnzW806kl/R/tkQGBcd
         m3SHAldqiM/CuM8kJQIMyywGIFosm3Qm4XY0s=
Date: Fri, 3 Oct 2008 01:26:32 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: sfr@canb.auug.org.au
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       torvalds@osdl.org
Subject: /proc git tree
Message-ID: <20081002212632.GA5852@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, add the following to the list of poor souls:

	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/proc.git proc

So far it consists of 5 trivial patches from -mm, in future there will
be smallish fs/proc/ reorganization, removing final defense line of ->read_proc()
users and officially bug-free¹ examples of showing stuff via seq_files.

Hope, nobody minds.

	Alexey

¹ Maximum allowed concentration of bugs is 0.42%/LOC.
