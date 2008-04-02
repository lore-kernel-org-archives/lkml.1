Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbYDBCgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbYDBCgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 22:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYDBCgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 22:36:09 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41048 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751516AbYDBCgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 22:36:08 -0400
X-Sasl-enc: YRAQbbxtqAh1aj1AblaKxqaP5JzsoCK6+2KNTMlKzPKC 1207103766
Date: Tue, 1 Apr 2008 23:36:05 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix kernel thread names that might offend users.
Message-ID: <20080402023605.GB1973@khazad-dum.debian.net>
References: <87r6dps3db.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r6dps3db.fsf@saeurebad.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Apr 2008, Johannes Weiner wrote:
> More and more GNOME users (especially Ubuntu) get confused by their
> process list showing several process names that seem to indicate
> KDE-related services.
> 
> To settle things down a bit on the bugtrackers, this patch renames all
> offending kernel threads into something that goes better with
> GNOME-based systems.

NAK.  By doing this, you are denying a golden opportunity to GNOME.  The
gProcessDisplayTaskListGTKWidget object MUST have a reason to hide from the
user all those pesky processes with names in brackets.  If your patch is
accepted, the oportunity to once again prove to all that GNOME knows
Better[tm] will be lost, as there won't be a reason to commit the patch to
gProcessDisplayTaskListGTKWidget anymore.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
