Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbXLBIEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbXLBIEf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 03:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbXLBIE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 03:04:27 -0500
Received: from smtp111.plus.mail.re1.yahoo.com ([69.147.102.74]:48985 "HELO
	smtp111.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751927AbXLBIE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 03:04:26 -0500
X-YMail-OSG: 4dyLDX8VM1kWJpYN1vyl79Q03Pokw1jsCF0W.ahW9fnVmW0jw7n8dNmR21CWVey4bFlLsPGxmEDyUKuHyIZdNZ.jSKe.n0jsoJjfZeuAZwdIBaQyvw--
Date: Sun, 2 Dec 2007 09:03:40 +0100
From: Borislav Petkov <yme@gollum.tnic>
To: Lucy McCoy <lucy@keyspan.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] keyspan: init termios properly
Message-ID: <20071202080340.GB6528@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de, Lucy McCoy <lucy@keyspan.com>,
	Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
	linux-kernel@vger.kernel.org
References: <46954.192.168.1.71.1195161016.webmail@192.168.1.71> <20071118131130.GA3991@gollum.tnic> <20071126141852.a609cdb6.akpm@linux-foundation.org> <20071130054500.GB17350@gollum.tnic> <4750471F.5050007@keyspan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4750471F.5050007@keyspan.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 09:23:43AM -0800, Lucy McCoy wrote:
> Hi All,
>
> I've been too busy to get to this but i'd rather not use the code fragment 
> i sent Boris to try.  It would be better to go ahead with the tty setup if 
> the pointer is not NULL, otherwise use the defaults and not reference the 
> NULL pointer. I'll see if I can get to this today.
you might also want to take a look at usa90_indat_callback() - there is
port->tty accessed again and this time it kills the machine completely when
something is sent over the serial line from the other end (through minicom, for
example). Oops is at

http://www.screenshots.cc/view_image/ab9a1837/cimg00772.jpg
-- 
Regards/Gruﬂ,
    Boris.
