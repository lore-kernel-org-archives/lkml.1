Return-Path: <linux-kernel-owner+w=401wt.eu-S1762739AbYETIcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762739AbYETIcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 04:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbYETIcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 04:32:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51269 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbYETIci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 04:32:38 -0400
Date: Tue, 20 May 2008 09:32:17 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Javier Herrero <jherrero@hvsistemas.es>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Bryan Wu <cooloney@kernel.org>
Subject: Re: b4aa54d951d38d7a989d6b6385494ef5ea7371d7 breaks some serial configurations
Message-ID: <20080520083217.GA10172@flint.arm.linux.org.uk>
References: <20080520073556.GA1090@flint.arm.linux.org.uk> <483286AF.2090302@hvsistemas.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483286AF.2090302@hvsistemas.es>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 10:07:11AM +0200, Javier Herrero wrote:
> Does the problem arise due to the change of inclusion order of 
> asm/serial.h (from after 8250.h to before 8250.h) ?

Yes.  It was placed where it was because of the dependencies of
asm/serial.h on the code between the two places.

The alternative solution is to get rid of the CONFIG_* compatibility
and update those asm/serial.h which reference the old symbols.
However, that's a larger patch.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
