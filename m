Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbYBRPOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbYBRPOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYBRPOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:14:12 -0500
Received: from mail-gw3.adaptec.com ([162.62.93.58]:49573 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbYBRPOL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:14:11 -0500
From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Omar Kilani <omar.kilani@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 18 Feb 2008 07:14:08 -0800
Subject: RE: aacraid: Host adapter reset request. SCSI hang ?
Thread-Topic: aacraid: Host adapter reset request. SCSI hang ?
Thread-Index: AchyP1lJyipJ/JELRX2PB4yjHnMACQAACilg
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F4399FCFFA@ADPE2K703.adaptec.com>
References: <f0cc3e3e0802152238t59498e3bv229d02ee3d96cea7@mail.gmail.com>
	<532ABFBDAAC3A34EB12EBA6CEC2838F4399FCFAF@ADPE2K703.adaptec.com>
 <20080218145427.21614b08@core>
In-Reply-To: <20080218145427.21614b08@core>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox [mailto:alan@lxorguk.ukuu.org.uk] sez:
> Sent: Monday, February 18, 2008 9:54 AM
> To: Salyzyn, Mark
> Cc: Omar Kilani; linux-kernel@vger.kernel.org
> Subject: Re: aacraid: Host adapter reset request. SCSI hang ?
>
> > pattern between the controller and Linux' SCSI subsystem.
> > The alternate workaround is for the user to adjust the
> > timeout in sysfs if it is shorter than this value.
> Does that actually work. I consistently see libata reporting
> 60 seconds but the commands are on 30 second timeouts and I've
> yet to get to the bottom of this

I 'assumed' it worked, the customer that reported a related problem went silent after I suggested the change.

libata's relationship with scsi may be different than aacraid's relationship? <shrug>

Sincerely -- Mark Salyzyn

        Eeek (a scientific term) - v
                - realization that a unit test was not performed.
                - See 'Screeeeeeeee' for more critical definition.
