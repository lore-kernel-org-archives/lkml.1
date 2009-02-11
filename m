Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbZBKOfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbZBKOfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbZBKOf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:35:26 -0500
Received: from verein.lst.de ([213.95.11.210]:60341 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755305AbZBKOfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:35:25 -0500
Date: Wed, 11 Feb 2009 15:35:22 +0100
From: Christoph Hellwig <hch@lst.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: get/put unaligned helpers
Message-ID: <20090211143521.GA18866@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just loked into using the new get/put unaligned helpers.  I must
say that I'm really unhappy about the lack of typing there.  We did
put all the sparse infrastructure in place to make sure we do have
strong typechecking for LE/Be types, but using these helpers defeats
that.

Can you please make these properly typed?
