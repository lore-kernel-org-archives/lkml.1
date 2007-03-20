Return-Path: <linux-kernel-owner+w=401wt.eu-S965795AbXCTCj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965795AbXCTCj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 22:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966075AbXCTCj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 22:39:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52724
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965795AbXCTCj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 22:39:58 -0400
Date: Mon, 19 Mar 2007 19:39:58 -0700 (PDT)
Message-Id: <20070319.193958.45741090.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Subject: ignore this posting
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Mon_Mar_19_19_39_58_2007_428)--"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

----Next_Part(Mon_Mar_19_19_39_58_2007_428)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Just trying to generate an example bounce so Intel can fix
their attachment email filters, ignore me.


----Next_Part(Mon_Mar_19_19_39_58_2007_428)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="git-suck.sh"

#!/bin/sh
#
# Usage: git suck path-to-tree
#
# Pull all patches relative to 'origin' from the tree specified
# and apply them to the current directory tree, keeping all changelog
# and authorship information identical.  It will update the dates
# of the changes of course.
(cd $1; git format-patch --suffix=.txt origin) || exit 1
for i in $1/*.txt
do
   sed 's/\[PATCH\] //' <$i >tmp.patch
   git-applymbox -k tmp.patch || exit 1
done
rm -f tmp.patch

----Next_Part(Mon_Mar_19_19_39_58_2007_428)----
