Return-Path: <linux-kernel-owner+w=401wt.eu-S1761332AbYJJRIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761332AbYJJRIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 13:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758926AbYJJRIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 13:08:15 -0400
Received: from star.netis.ru ([213.187.127.146]:56044 "EHLO star.netis.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758400AbYJJRIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 13:08:14 -0400
X-Greylist: delayed 1055 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Oct 2008 13:08:14 EDT
Date: Fri, 10 Oct 2008 20:49:53 +0400
From: "Alexander V. Lukyanov" <lav@netis.ru>
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@computergmbh.de>
Cc: Ncurses Developers <ncurses-dev@gnu.org>
Subject: Re: linux 2.6.26 vt back_color_erase
Message-ID: <20081010164953.GA27092@night.netis.ru>
References: <20081003081147.GA16414@night.netis.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003081147.GA16414@night.netis.ru>
User-Agent: Mutt/1.5.11
X-NETIS-MailScanner-Information: Please contact NETIS Telecom for more information <info@netis.ru> (+7 4852 797797)
X-NETIS-MailScanner-ID: m9AGnaHj011015
X-NETIS-MailScanner: Found to be clean
X-NETIS-MailScanner-SpamCheck: not spam, SpamAssassin (not cached, score=0,
	required 6, autolearn=disabled)
X-NETIS-MailScanner-From: lav@netis.ru
X-NETIS-MailScanner-To: jengelh@computergmbh.de,
	linux-kernel@vger.kernel.org, ncurses-dev@gnu.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 12:11:47PM +0400, Alexander V. Lukyanov wrote:
> Current linux kernel has broken bce semantics. Now insert_line and
> delete_line clear the new lines with default color and not with the current
> background as they should, and what is expected by ncurses.
> 
> vc->vc_scrl_erase_char was introduced in 2.6.26 for some reason. I beleave
> this change should be backed out.

I think that the test cases Jan provided could be fixed by temporary
changing erase char when doing cr/lf when vc->vc_need_wrap is true.
There is no need to change erase character for all scrolling operations.

--
   Alexander.
