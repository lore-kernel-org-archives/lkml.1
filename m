Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbYKBJFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbYKBJFI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 04:05:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbYKBJEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 04:04:46 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:59354 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbYKBJEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 04:04:44 -0500
Date: Sun, 2 Nov 2008 09:04:36 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: Nick Kossifidis <mickflemm@gmail.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, willy@linux.intel.com,
       lrodriguez@atheros.com
Subject: Re: ath5k gets lost with eeepc-laptop removal
Message-ID: <20081102090436.GA10983@srcf.ucam.org>
References: <20081031110502.18e33eba@doriath.conectiva> <40f31dec0810310926p6edd0af5o24d7616eb54c6d0@mail.gmail.com> <20081031151901.2d68c32d@doriath.conectiva> <40f31dec0810311133v65001e59h28cf6946ac3f14e7@mail.gmail.com> <20081031164351.3e4a9d4e@doriath.conectiva> <20081031164859.7808de23@doriath.conectiva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031164859.7808de23@doriath.conectiva>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 04:48:59PM -0200, Luiz Fernando N. Capitulino wrote:

>  Hmm. You think this could be related, Matthew?

No, I think that's unrelated. But unloading eeepc-laptop will cause 
rfkill to shut down the platform radio, which on the eee triggers a PCIe 
unplug of the card and powers it down.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
