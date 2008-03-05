Return-Path: <linux-kernel-owner+w=401wt.eu-S933843AbYCENIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933843AbYCENIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 08:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764426AbYCENIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 08:08:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:50493 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764440AbYCENIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 08:08:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=vq8lKejw3hBL5+Bii0IsYcQ7fwikUkn+COWnQYV7RfaCGelagOdLuYxNQoY8K7lybptiM4mx5j7xmFIr12LYhlMMx9RwVsAZYSJQORY05BsICGJdUWgKuvtS33vjfvnVQcFMm/FDXlhymSvKUoTQSGTaR3pn1buebzFPUvm2tHY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 3/3] pata: "I do not think it means, what you think it means."
Date: Wed, 5 Mar 2008 14:21:13 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Andrew Morton <akpm@linux-foundation.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, alan@redhat.com,
       linux-kernel@vger.kernel.org
References: <200803042316.m24NGI7k002489@imap1.linux-foundation.org> <20080304173058.7679b7c8.akpm@linux-foundation.org> <20080305115610.397b3ea3@the-village.bc.nu>
In-Reply-To: <20080305115610.397b3ea3@the-village.bc.nu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803051421.14167.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 March 2008, Alan Cox wrote:
> 
> > I didn't know any of that.  The changelog might have been kinda fun, but
> > given that it failed to tell us that the patch fixes data-corruption
> > errors, the changelog was excrutiatingly bad.
> 
> I have no reason/evidence to believe it fixes data corruption errors of
> any kind. For the specific combinations of device it should simply avoid
> a long pause, complaints and a switch to lower speeds.

http://www.mail-archive.com/linux-ide@vger.kernel.org/msg16599.html

There is strange coincidence with being on the blacklist and FIFO corruption.

https://bugzilla.redhat.com/show_bug.cgi?id=433557

Bugzilla Bug 433557: Data corrupion with Fedora8 on HPT370 disk controller (Abit BX133 mobo)

IBM-DTLA-307030 is on the blacklist....

[ there can be more libata problems involved, anyway FC6 w/IDE works fine ]

> The ATA disk case with serverworks (which is a potential corruptor) was
> always correctly handled.

for OSB4 yes but...

/* Seagate Barracuda ATA IV Family drives in UDMA mode 5
 * can overrun their FIFOs when used with the CSB5 */

static const char *csb_bad_ata100[] = {

Thanks,
Bart
