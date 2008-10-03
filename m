Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbYJCIbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbYJCIbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 04:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbYJCIbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 04:31:44 -0400
Received: from fire.netis.ru ([193.233.48.99]:60695 "EHLO fire.netis.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbYJCIbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 04:31:43 -0400
X-Greylist: delayed 1117 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Oct 2008 04:31:42 EDT
Date: Fri, 3 Oct 2008 12:11:47 +0400
From: "Alexander V. Lukyanov" <lav@netis.ru>
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Ncurses Developers <ncurses-dev@gnu.org>
Subject: linux 2.6.26 vt back_color_erase
Message-ID: <20081003081147.GA16414@night.netis.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
X-NETIS-MailScanner-Information: Please contact NETIS Telecom for more information <info@netis.ru> (+7 4852 797797)
X-NETIS-MailScanner-ID: m938BmYm016576
X-NETIS-MailScanner: Found to be clean
X-NETIS-MailScanner-SpamCheck: not spam, SpamAssassin (not cached, score=0,
	required 6, autolearn=disabled)
X-NETIS-MailScanner-From: lav@netis.ru
X-NETIS-MailScanner-To: linux-kernel@vger.kernel.org, ncurses-dev@gnu.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Current linux kernel has broken bce semantics. Now insert_line and
delete_line clear the new lines with default color and not with the current
background as they should, and what is expected by ncurses.

vc->vc_scrl_erase_char was introduced in 2.6.26 for some reason. I beleave
this change should be backed out.

-- 
   Alexander.
