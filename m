Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbZJFB7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbZJFB7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 21:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbZJFB7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 21:59:53 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:31997 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbZJFB7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 21:59:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=K/lOKbN61Zw5S01jc+jMXKwO3Zb+UvY/aKbm2YAvm35xIdhvTGf5wgUrxLw72msCul
         QrvJqxVS5O9yjYxR11Z47JZ7VCkFato8VeVMHx+pirdwePvrHvVreeVJ9PQWqruyGG0S
         E8SzfXCvO9T4G4WX/imx/N23nfdYqNFaQG0Hk=
Message-ID: <4ACAA450.6030405@gmail.com>
Date: Mon, 05 Oct 2009 19:58:40 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sata_via: SError: { UnrecovData Proto TrStaTrns }
References: <m3my46yo5g.fsf@intrepid.localdomain>
In-Reply-To: <m3my46yo5g.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2009 07:18 AM, Krzysztof Halasa wrote:
> Hi,
>
> What could that be?
> VIA VT6421A mini-PCI card and SATA SSD from Transcend. IXP425 (ARM)
> little-endian CPU. 128 MB RAM - VT6421A can access only the first 64 MB
> of system RAM, but there is bounce buffering (a la swiotlb) for the
> rest.
>
> Sometimes it produces:
>
> ata1.00: exception Emask 0x12 SAct 0x0 SErr 0x1000500 action 0x6
> ata1.00: BMDMA stat 0x5
> ata1: SError: { UnrecovData Proto TrStaTrns }
> ata1.00: cmd c8/00:20:b7:18:38/00:00:00:00:00/e0 tag 0 dma 16384 in
>           res 51/40:20:b7:18:38/00:00:00:00:00/e0 Emask 0x12 (ATA bus error)
> ata1.00: status: { DRDY ERR }
> ata1.00: error: { UNC }
> ata1: hard resetting link
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> ata1.00: configured for UDMA/100
> ata1: EH complete
>
> Any ideas?

Presumably a SATA bus communication error. Are you sure the SATA 
connections and cable are good?
