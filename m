Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbXL1N5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbXL1N5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 08:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbXL1N5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 08:57:12 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:50057 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbXL1N5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 08:57:11 -0500
X-Greylist: delayed 975 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Dec 2007 08:57:10 EST
Date: Fri, 28 Dec 2007 14:40:36 +0100
From: Andi Kleen <andi@firstfloor.org>
To: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, rob@landley.com
Subject: Kerneldoc comments in files not mentioned by *.tmpl
Message-ID: <20071228134036.GA482@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 28 Dec 2007 13:34:32.0941 (UTC) FILETIME=[615AB9D0:01C84956]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I added kerneldoc comments to some files and was a little surprised that
they didn't appear in make mandocs output. It turns out only functions in files
mentioned in Documentation/DocBook/*.tmpl are extracted. Since that's a 
pretty unknown requirement (at least I didn't know it) I suppose a lot
of the kerneldoc annotations actually are never generated because of this.

Should that be changed and let the scripts hunt for kerneldoc in all
source files?

A potential problem is that already the kerneldocs contain a lot 
of fairly useless driver internal funcions (e.g. nobody does care
a lot about internal MPT interfaces). But that problem is already
there and it's better to have too many than not enough in mandocs. 

-Andi
