Return-Path: <linux-kernel-owner+w=401wt.eu-S1161424AbXBHFqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161424AbXBHFqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 00:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161535AbXBHFqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 00:46:33 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:61418 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161424AbXBHFqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 00:46:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ijkEel5uyB9UptaakBty1M5kl4yXgH6Td7j2PrtbOfwjE6Gq2ddqiJgAQmX0uN//Xg3TqUn86tpXo6WzqpIxJcGz3/hikzTll7b9QX0/QOyjxsafFt6surDR6P1FHAEMmw5QKQjEF9w9a6FHUMoblM3cw/Ky4cYMZySgROYSk8U=
Message-ID: <1a297b360702072146i649c0020q25b7b8765b3f666b@mail.gmail.com>
Date: Thu, 8 Feb 2007 09:46:31 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Grant Grundler" <grundler@parisc-linux.org>
Subject: Re: 2.6.20 PCI Cannot allocate resource region 2
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, greg@kroah.com
In-Reply-To: <20070207065803.GA15076@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1a297b360702041709l3b0309c7y8fcd33df1d487889@mail.gmail.com>
	 <20070206045528.GA4228@colo.lackof.org>
	 <20070206050331.GB4228@colo.lackof.org>
	 <20070205213339.80239a22.akpm@linux-foundation.org>
	 <20070206084638.GB20752@colo.lackof.org>
	 <1a297b360702060313n34a8f941oebf9f373630b070f@mail.gmail.com>
	 <1a297b360702060352y3faa0f46i7c4a01499fae2eff@mail.gmail.com>
	 <20070207065803.GA15076@colo.lackof.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/07, Grant Grundler <grundler@parisc-linux.org> wrote:
> On Tue, Feb 06, 2007 at 03:52:47PM +0400, Manu Abraham wrote:
> > >attaching a dump of the regs (on 2.6.17.7) as well as the diff
> >
> > The device now works, used the demodulator driver alongwith the bridge
> > driver.
>
> Ok - thanks for the dmesg output and log. I suspect you've already
> tried cycling power on the machine (If not, please do).
> I have no idea what M$ XP was doing that might "fix" the problem.
>
> I was just suspicious of our byte accesses to the same dword.
> To answer you previous question, it's possible that M$ only
> uses dword accesses. I don't know.

Does it sound too weird, if our PCI accesses could accidentally
overwrite EEPROM contents on cards that have the EEPROM, R/W ?

we came across with lot of issues on the same unfortunately under
Linux only this issues comes up, we used to sling mud at each other,
probably for bad I2C communications on a BT878 based chip.

Recently, somebody came across a strange case where, booting into
Windows , fixed his EEPROM contents. Since i have the driver sources
for the described card from the vendor for windows, i don't see how
any way in which the Windows driver does rewriting the EEPROM.

http://thread.gmane.org/gmane.linux.drivers.dvb/23911/focus=31185

Does this have any relation to the current situation ?

regards,
manu
