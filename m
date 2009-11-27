Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187AbZK0IRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbZK0IRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 03:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbZK0IRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 03:17:31 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:48479 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbZK0IRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 03:17:30 -0500
Date: Fri, 27 Nov 2009 08:16:56 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ming Lei <tom.leiming@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-mips@linux-mips.org
Subject: Re: [PATCH 06/38] move iodev_remove to .devexit.text
Message-ID: <20091127081656.GA6948@linux-mips.org>
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-4-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-6-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1259096853-18909-6-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 10:07:01PM +0100, Uwe Kleine-König wrote:

> The function iodev_remove is used only wrapped by __devexit_p so define
> it using __devexit.

Thanks, queued for 2.6.33.

  Ralf
