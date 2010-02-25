Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960Ab0BYQvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 11:51:40 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:13483 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758948Ab0BYQvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:51:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=S+1lDoTOrnb4Hw8upS/vCL2Khg92lJ8WcYOwY14RHd2UWVZfX7QRcRlxs4YfyVj+/w
         51393HFOK05SuqU2hlCxt12egT8ztrNIG+oVHYBCrPulFofZiXx0wBKEl+joKINybapP
         Q49gh01vVlE97LLVdEd0A9Hwme51ea4MYAmPU=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: linux-serial@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] serial: Add driver for the Altera JTAG UART
References: <1267108523-32767-1-git-send-email-tklauser@distanz.ch>
Date: Thu, 25 Feb 2010 17:45:33 +0100
In-Reply-To: <1267108523-32767-1-git-send-email-tklauser@distanz.ch> (Tobias
	Klauser's message of "Thu, 25 Feb 2010 15:35:22 +0100")
Message-ID: <87ocjd5knm.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Tobias" == Tobias Klauser <tklauser@distanz.ch> writes:

 Tobias> Add an UART driver for the JTAG UART component available as a SOPC
 Tobias> (System on Programmable Chip) component for Altera FPGAs.

 Tobias> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
 
 Tobias> +config SERIAL_ALTERA_JTAGUART
 Tobias> +	bool "Altera JTAG UART support"
 Tobias> +	depends on EMBEDDED

Don't depend on EMBEDDED - There's embedded devices not using
CONFIG_EMBEDDED and kernel configs for PCs using it.

-- 
Bye, Peter Korsgaard
