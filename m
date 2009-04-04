Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbZDDRyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbZDDRyo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 13:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbZDDRyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 13:54:35 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48200 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZDDRye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 13:54:34 -0400
Date: Sat, 4 Apr 2009 18:54:28 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, shurik@gwu.edu
Subject: Re: qcserial/gobi firmware loader
Message-ID: <20090404175428.GA6651@srcf.ucam.org>
References: <20090401203726.GA17485@srcf.ucam.org> <20090403025654.GA20146@suse.de> <20090403135719.GD19774@srcf.ucam.org> <20090403150301.GA25846@suse.de> <20090403151237.GA25994@suse.de> <20090403164551.GA23689@srcf.ucam.org> <20090404152731.GA5080@srcf.ucam.org> <ac3eb2510904041051k45599297s6a97094702664aac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510904041051k45599297s6a97094702664aac@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 04, 2009 at 07:51:06PM +0200, Kay Sievers wrote:
> This misses a '=':
>   GOTO "gobi_rules_end"
> 
> This:
>   /dev/%k
> should be:
>   $env{DEVNAME}

Thanks, fixed those.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
