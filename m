Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbZLDLSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbZLDLSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 06:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbZLDLSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 06:18:45 -0500
Received: from procserver.webwayone.co.uk ([62.8.115.202]:55467 "EHLO
	procserver.webwayone.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754403AbZLDLSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 06:18:45 -0500
X-Greylist: delayed 643 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Dec 2009 06:18:44 EST
DomainKey-Signature: a=rsa-sha1; s=procserver; d=webwayone.co.uk; c=nofws; q=dns;
	h=x-dkim:dkim-signature:x-batv:x-virus-status:
	x-virus-scanned:x-dkim:authentication-results:from:to:cc:subject:date:
	message-id:user-agent:mime-version:content-type;
	b=AfgU3VyPlXlN3OHV6xe3O0JNetAOCVDxd86yCq4RkuprIOf9MK/fmo+KAcQbLMyPo
	ix2VEj/fcV9GdJeiGaGsw==
X-DKIM: OpenDKIM Filter v1.1.1.dev procserver.webwayone.co.uk nB4B85Dd005928
X-BATV: Sendmail BATV Filter v0.4.0 procserver nB4B85Dd005928
X-DKIM: OpenDKIM Filter v1.1.1.dev procserver.webwayone.co.uk nB4B85Dd005928
Authentication-Results: procserver.webwayone.co.uk; dkim=none
	(no signature) header.i=unknown; dkim-adsp=none
From: Graham Murray <gmurray@webwayone.co.uk>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de
Subject: 2.6.32 CONFIG_SX marked as BROKEN
Date: Fri, 04 Dec 2009 11:08:05 +0000
Message-ID: <7wd42vyp2i.fsf@webwayone.co.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 412145947adfca60a4b5b4893fbae82dffa25edd marked CONFIG_SX as
Broken. The commit comments state that there are no users. We are using
SX cards in production servers. I discovered this when I attempted to
upgrade a development server to 2.6.32 and it failed to find the cards.
