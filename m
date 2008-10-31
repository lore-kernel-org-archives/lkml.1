Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbYJaOXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbYJaOXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 10:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYJaOX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 10:23:27 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58344 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYJaOX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 10:23:27 -0400
Date: Fri, 31 Oct 2008 14:23:18 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       willy@linux.intel.com, lrodriguez@atheros.com
Subject: Re: ath5k gets lost with eeepc-laptop removal
Message-ID: <20081031142318.GA9009@srcf.ucam.org>
References: <20081031110502.18e33eba@doriath.conectiva> <490B0D75.8020601@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490B0D75.8020601@tuffmail.co.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 01:51:49PM +0000, Alan Jenkins wrote:

> Matthew: I nagged you twice about different consequences of this 
> commit, so here's a third :).  You said rfkill no longer automatically 
> frobs on suspend/resume, which was what I was worried about last time.  
> Should the core code also be modified so it doesn't do anything when 
> the rfkill device is unregistered?

I think there's definitely an argument in favour of that, though I 
suspect that's a design feature - if you remove the control mechanism 
for a radio, the safe state for that radio to be in is not transmitting.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
