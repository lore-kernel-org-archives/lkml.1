Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbZGUL0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbZGUL0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 07:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbZGUL0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 07:26:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49901 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbZGUL0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 07:26:09 -0400
Date: Tue, 21 Jul 2009 12:26:07 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hp-wmi: improve rfkill support
Message-ID: <20090721112607.GA17377@srcf.ucam.org>
References: <4A65A2F9.1060509@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A65A2F9.1060509@tuffmail.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 12:14:01PM +0100, Alan Jenkins wrote:
> 1) Add support for reading the hardware blocked state.  Previously
>    we read a combination of the hardware and software blocked states,
>    reporting it as the software blocked state.  This caused some
>    confusing behaviour.
> 
> 2) The software state is persistent, mark it as such.
> 
> 3) Check rfkill in the resume handler.  Both the hard and soft
>    blocked states may change over hibernation.
> 
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>
Acked-by: Matthew Garrett <mjg@redhat.com>

-- 
Matthew Garrett | mjg59@srcf.ucam.org
