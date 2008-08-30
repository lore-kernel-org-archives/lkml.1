Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbYH3LBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbYH3LBr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 07:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbYH3LBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 07:01:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:38903 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbYH3LBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 07:01:38 -0400
Message-ID: <48B92846.7050004@kernel.org>
Date: Sat, 30 Aug 2008 13:00:22 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: xerces8 <xerces8@butn.net>
CC: Sergey Spiridonov <sena@hurd.homeunix.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: GA-MA790FX-DS5 SATA ahci NCQ erros on Jmicron 20360/20363 	(JMB363)
 kernel 2.6.25-2 Debian/Lenny
References: <g8p6po$nm$1@ger.gmane.org> <48B0916C.4080805@garzik.org> <g8q9mg$v2p$1@ger.gmane.org> <WorldClient-F200808241844.AA44240046@butn.net>
In-Reply-To: <WorldClient-F200808241844.AA44240046@butn.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 30 Aug 2008 11:01:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xerces8 wrote:
> I have a JMB363 myself and it has its share of problems.
> I would say it is buggy hardware. (why would they otherwise
> release a new windows driver every week ? if not to workaround
> bugs in HW ;-)

Well, FWIW, JMB ahci's are one of my favorites and usually very well
behaved.

> My WD MyBook Studio Edition 500 GB external eSATA drive does not
> work on the JMB363 correctly no matter what I try. Both
> under linux and windows. I think the best was 30 minutes of
> (apparent) error free operation under windows.

This one is being discussed both with JMB and WD.  It seems the bridge
chip used in the WD external drives is somehow incompatible with the
JMB ahci's.  Don't know whose fault it is or how it can be worked
around yet.  The issue is being tracked in the following bugzilla.

  http://bugzilla.kernel.org/show_bug.cgi?id=9913

-- 
tejun
