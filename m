Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab0BPQWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 11:22:33 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:51832 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757188Ab0BPQWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 11:22:31 -0500
Date: Tue, 16 Feb 2010 17:22:24 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <avorontsov@ru.mvista.com>,
       David Woodhouse <dwmw2@infradead.org>
Message-ID: <20100216162223.GA28375@enneenne.com>
Mail-Followup-To: Grazvydas Ignotas <notasas@gmail.com>,
	linux-kernel@vger.kernel.org,
	Anton Vorontsov <avorontsov@ru.mvista.com>,
	David Woodhouse <dwmw2@infradead.org>
References: <1266011806-31747-1-git-send-email-notasas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266011806-31747-1-git-send-email-notasas@gmail.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/4] power_supply: bq27x00: remove double endian swap
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 11:56:46PM +0200, Grazvydas Ignotas wrote:
> The bq27x00 registers are little endian, so just read them as such
> and don't do double endian swap on LE machines.
> 
> This also gets rid of strange looking shift that was done after
> reading 8bit register because endian swap in bq27x00_read() was
> messing it up.
> 
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

Acked-by: Rodolfo Giometti <giometti@linux.it>

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
