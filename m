Return-Path: <linux-kernel-owner+w=401wt.eu-S1758367AbXFZR7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367AbXFZR7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 13:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757277AbXFZR7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 13:59:10 -0400
Received: from www.tammen.de ([62.206.99.154]:57061 "EHLO mail.tammen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757235AbXFZR7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 13:59:09 -0400
X-Greylist: delayed 2000 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jun 2007 13:59:09 EDT
From: Heinz Ulrich Stille <hus@design-d.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Frequent SATA resets with sata_nv (fwd)
User-Agent: KMail/1.9.7
Cc: ide <linux-ide@vger.kernel.org>
References: <fa.Z5bo5y2TvW4efa6slAJpcdPwqAA@ifi.uio.no> <467ECBB8.2030706@shaw.ca> <alpine.DEB.0.99.0706251207230.20899@cheetah.fastcat.org>
In-Reply-To: <alpine.DEB.0.99.0706251207230.20899@cheetah.fastcat.org>
X-Face: 4mP]9aFSZN&|I]TOVXU]ip[QEBP^RNKxLkj?@0A{KRjs9>QuA{bW
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1903
Date: Tue, 26 Jun 2007 19:29:34 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200706261929.34303.hus@design-d.de>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Jun 26 19:29:47 2007
X-DSPAM-Confidence: 0.9910
X-DSPAM-Improbability: 1 in 11063 chance of being spam
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 46814d0b207861255019845
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 June 2007, Matthew "Cheetah" Gabeler-Lee wrote:
> On Sun, 24 Jun 2007, Robert Hancock wrote:
> I selected that model in part because it at least claimed to support
> NCQ.  I'm not sure if it reflects NCQ or not, but I do have
> /sys/block/sd[abc]/device/queue_{depth,type} which show simple and 31
> respectively.  Samsung's page for the drive also says it supports NCQ:

I seem to have the same problem, just not as frequent: four drives of this
type, connected to an SiI 3132 and an nVidia MCP55; resets occur on both
controllers, and only with this drive type, not with several Maxtor 6B200M0.
I never thought to check, but all drives on the nv controller have NCQ
disabled according to /sys/block. So maybe it's not (directly) NCQ related?

MfG, Ulrich

-- 
Heinz Ulrich Stille / Tel.: +49-541-9400473 / Fax: +49-541-9400450
design_d gmbh / Wilhelmstr. 16 / 49076 Osnabrück / www.design-d.de
Osnabrück HRB 19116 / Geschäftsführer: Günter Tammen, Rolf Tammen

