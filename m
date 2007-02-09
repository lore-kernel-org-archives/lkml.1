Return-Path: <linux-kernel-owner+w=401wt.eu-S2992799AbXBIUBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992799AbXBIUBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 15:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992798AbXBIUBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 15:01:11 -0500
Received: from outmx014.isp.belgacom.be ([195.238.4.69]:36926 "EHLO
	outmx014.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992799AbXBIUBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 15:01:10 -0500
Date: Fri, 9 Feb 2007 21:01:08 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       R.E.Wolff@BitWizard.nl, jrv@vanzandt.mv.com, alex@linuxhacker.org,
       support.linux@omnikey.com, a.zummo@towertech.it,
       tpmdd_devel@lists.sourceforge.net, steve@navaho.co.uk,
       hero@ihg.uni-duisburg.de, fuganti@conectiva.com.br, gorgo@itc.hu,
       khollis@bitgate.com, lethal@linux-sh.org
Subject: Re: [PATCH 2/2] Char: timers cleanup
Message-ID: <20070209200108.GA2510@infomag.infomag.iguana.be>
References: <156451408997831024@wsc.cz> <398523843890216659@wsc.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <398523843890216659@wsc.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> timers cleanup
> 
> - Use timer macros to set function and data members and to modify
>   expiration time.
> - Use DEFINE_TIMER for global timers and do not init them at run-time in
>   these cases.
> - del_timer_sync is common in most cases -- we want to wait for timer
>   function if it's still running.

For the watchdog drivers: the timers are only used if the watchdog is active.
Why should we not init them at run time but use the DEFINE_TIMER macro?
Personnaly I prefer to use the same syntax in all the watchdog drivers
(thus either DEFINE_TIMER or either setup_timer() ).

Greetings,
Wim.

