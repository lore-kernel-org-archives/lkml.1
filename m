Return-Path: <linux-kernel-owner+w=401wt.eu-S1757754AbYFHXLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbYFHXLZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 19:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757347AbYFHXLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 19:11:08 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38913 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342AbYFHXLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 19:11:07 -0400
Date: Mon, 9 Jun 2008 00:11:05 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: BUG: unable to handle kernel paging request at f8dbf000 "isight_firmware"
Message-ID: <20080608231105.GA28358@srcf.ucam.org>
References: <dd18b0c30806081151q7895a930te5fd374e35471c7a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd18b0c30806081151q7895a930te5fd374e35471c7a@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 06:51:42PM +0000, Justin Mattock wrote:

> Now on to the status with isight firmware, It seems The two modules
> are loading uvcvideo and isight_firmware, but there not talking with
> each other upon booting,

I'm not quite sure I understand. They don't talk to each other as such - 
the firmware driver loads the firmware, at which point the isight will 
disconnect and reappear with a new USB id. uvcvideo should then be able 
to bind. What are you actually seeing?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
